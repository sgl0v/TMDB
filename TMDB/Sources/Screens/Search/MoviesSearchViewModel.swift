//
//  MoviesSearchViewModel.swift
//  TMDB
//
//  Created by Maksym Shcheglov on 02/10/2019.
//  Copyright © 2019 Maksym Shcheglov. All rights reserved.
//

import UIKit
import Combine

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
    struct Schedulers {
        private init() {}
        static let main = RunLoop.main
        static let background = OperationQueue()
    }

    init(navigator: MoviesSearchNavigator) {
        self.navigator = navigator
    }

    func transform(input: MoviesSearchViewModelInput) -> MoviesSearchViewModelOuput {
        let trigger = Publishers.Merge(input.appear.map({ "hello" }), input.search.debounce(for: .seconds(2), scheduler: RunLoop.main)).eraseToAnyPublisher()
        let searchResult = search(trigger).receive(on: Schedulers.main).share()
        let movies = searchResult
            .flatMap({ result -> AnyPublisher<[Movie], Never> in
                guard case .success(let movies) = result else { return .empty() }
                return .just(movies)
            })
            .removeDuplicates()
            .subscribe(on: Schedulers.background)
            .eraseToAnyPublisher()
        let loading = Publishers.Merge(trigger.map({_ in true }), searchResult.map({ _ in false })).eraseToAnyPublisher()
        let error = searchResult
            .flatMap({ result -> AnyPublisher<Error, Never> in
                guard case .failure(let error) = result else { return .empty() }
                return .just(error)
            })
            .eraseToAnyPublisher()

        Publishers.CombineLatest(movies, input.selection)
            .receive(on: RunLoop.main)
            .map({ (movies, idx) in return movies[idx].id })
            .sink(receiveValue: { [unowned self] movieId in self.navigator?.showDetails(forMovie: "\(movieId)") })
            .store(in: &cancellables)

        return MoviesSearchViewModelOuput(movies: movies, loading: loading, error: error)
    }

    private func search(_ textInput: AnyPublisher<String, Never>) -> AnyPublisher<Result<[Movie], Error>, Never> {
        let requestPublisher: AnyPublisher<Result<[Movie], Error>, Never> = URLSession.shared.dataTaskPublisher(for: URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=181af7fcab50e40fabe2d10cc8b90e37&language=en-US&page=1")!)
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
            .decode(type: Movies.self, decoder: JSONDecoder())
        .map { Result<[Movie], Error>.success($0.items) }
        .catch ({ error -> AnyPublisher<Result<[Movie], Error>, Never> in
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
