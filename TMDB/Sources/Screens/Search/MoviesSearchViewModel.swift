//
//  MoviesSearchViewModel.swift
//  TMDB
//
//  Created by Maksym Shcheglov on 02/10/2019.
//  Copyright © 2019 Maksym Shcheglov. All rights reserved.
//

import UIKit
import Combine

struct Post: Decodable, Equatable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

extension Publisher {

    /// - seealso: https://twitter.com/peres/status/1136132104020881408
    func flatMapLatest<T: Publisher>(_ transform: @escaping (Self.Output) -> T) -> Publishers.SwitchToLatest<T, Publishers.Map<Self, T>> where T.Failure == Self.Failure {
        map(transform).switchToLatest()
    }
}

extension Publisher {

    static func empty() -> AnyPublisher<Output, Failure> {
        return Empty().eraseToAnyPublisher()
    }

    static func just(_ output: Output) -> AnyPublisher<Output, Failure> {
        return Just(output)
            .catch { _ in AnyPublisher<Output, Failure>.empty() }
            .eraseToAnyPublisher()
    }

    static func fail(_ error: Failure) -> AnyPublisher<Output, Failure> {
        return Fail(error: error).eraseToAnyPublisher()
    }
}

enum URLSessionError: Error {
    case invalidResponse
    case serverErrorMessage(statusCode: Int, data: Data)
    case urlError(URLError)
}

class MoviesSearchViewModel: MoviesSearchViewModelType {

    private weak var navigator: MoviesSearchNavigator?
    private var cancellables: [AnyCancellable] = []

    init(navigator: MoviesSearchNavigator) {
        self.navigator = navigator
    }

    func transform(input: MoviesSearchViewModelInput) -> MoviesSearchViewModelOuput {
        let trigger = Publishers.Merge(input.appear.map({ "" }), input.search.debounce(for: .seconds(2), scheduler: RunLoop.main)).eraseToAnyPublisher()
        let searchResult = search(trigger).receive(on: RunLoop.main).share()
        let posts = searchResult
            .flatMap({ result -> AnyPublisher<[Post], Never> in
                guard case .success(let posts) = result else { return .empty() }
                return .just(posts)
            })
            .removeDuplicates()
            .eraseToAnyPublisher()
        let loading = Publishers.Merge(trigger.map({_ in true }), searchResult.map({ _ in false })).eraseToAnyPublisher()
        let error = searchResult
            .flatMap({ result -> AnyPublisher<Error, Never> in
                guard case .failure(let error) = result else { return .empty() }
                return .just(error)
            })
            .eraseToAnyPublisher()

        input.selection
            .combineLatest(posts, { (idx, posts) in return posts[idx].id })
            .sink(receiveValue: { [unowned self] sessionId in self.navigator?.showDetails(forMovie: "\(sessionId)") })
            .store(in: &cancellables)

        return MoviesSearchViewModelOuput(posts: posts, loading: loading, error: error)
    }

    private func search(_ textInput: AnyPublisher<String, Never>) -> AnyPublisher<Result<[Post], Error>, Never> {
        let requestPublisher: AnyPublisher<Result<[Post], Error>, Never> = URLSession.shared.dataTaskPublisher(for: URL(string: "https://jsonplaceholder.typicode.com/posts")!)
            .mapError { URLSessionError.urlError($0) }
            .print()
            .flatMap { data, response -> AnyPublisher<Data, URLSessionError> in
                guard let response = response as? HTTPURLResponse else {
                    return .fail(.invalidResponse)
                }

                guard 200..<300 ~= response.statusCode else {
                    return .fail(.serverErrorMessage(statusCode: response.statusCode, data: data))
                }

                return .just(data)
            }
            .decode(type: [Post].self, decoder: JSONDecoder())
            .map { Result<[Post], Error>.success($0) }
        .catch ({ error -> AnyPublisher<Result<[Post], Error>, Never> in
            print(error)
            return .just(.failure(error))
        })
        .eraseToAnyPublisher()
        return textInput
            .filter({ !$0.isEmpty })
            .flatMapLatest({ _ in requestPublisher })
            .eraseToAnyPublisher()
    }
}
