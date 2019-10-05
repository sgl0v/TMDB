//
//  MoviesSearchViewModel.swift
//  TMDB
//
//  Created by Maksym Shcheglov on 02/10/2019.
//  Copyright © 2019 Maksym Shcheglov. All rights reserved.
//

import UIKit
import Combine

final class MoviesSearchViewModel: MoviesSearchViewModelType {

    private weak var navigator: MoviesSearchNavigator?
    private let useCase: MoviesUseCaseType
    private var cancellables: [AnyCancellable] = []

    init(useCase: MoviesUseCaseType, navigator: MoviesSearchNavigator) {
        self.useCase = useCase
        self.navigator = navigator
    }

    func transform(input: MoviesSearchViewModelInput) -> MoviesSearchViewModelOuput {
        let trigger = input.search.filter({ !$0.isEmpty }).debounce(for: .milliseconds(500), scheduler: RunLoop.main).eraseToAnyPublisher()
        let searchResult = trigger
            .flatMapLatest({[unowned self] query in self.useCase.searchMovies(with: query) })
            .share()
        let movies = searchResult
            .flatMap({ result -> AnyPublisher<[MovieViewModel], Never> in
                guard case .success(let movies) = result else { return .empty() }
                return .just(self.viewModels(from: movies))
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
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [unowned self] movieId in self.navigator?.showDetails(forMovie: movieId) })
            .store(in: &cancellables)

        return MoviesSearchViewModelOuput(movies: movies, loading: loading, error: error)
    }

    private func viewModels(from movies: [Movie]) -> [MovieViewModel] {
        return movies.map({[unowned self] movie in
            return MovieViewModelBuilder.viewModel(from: movie, imageLoader: {[unowned self] movie in self.useCase.loadImage(for: movie) })
        })
    }

}
