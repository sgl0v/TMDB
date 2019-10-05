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
        let trigger = Publishers.Merge(input.appear.map({ "hello" }), input.search.debounce(for: .seconds(2), scheduler: RunLoop.main)).eraseToAnyPublisher()
        let searchResult = trigger
            .filter({ !$0.isEmpty })
            .flatMapLatest({[unowned self] query in self.useCase.searchMovies(with: query) })
            .share()
        let movies = searchResult
            .flatMap({ result -> AnyPublisher<[MovieViewModel], Never> in
                guard case .success(let movies) = result else { return .empty() }
                return .just(movies.map({[unowned self] movie in self.viewModel(from: movie) }))
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

        Publishers.CombineLatest(movies, input.selection)
            .receive(on: RunLoop.main)
            .map({ (movies, idx) in return movies[idx].id })
            .sink(receiveValue: { [unowned self] movieId in self.navigator?.showDetails(forMovie: "\(movieId)") })
            .store(in: &cancellables)

        return MoviesSearchViewModelOuput(movies: movies, loading: loading, error: error)
    }

    private func viewModel(from movie: Movie) -> MovieViewModel {
        return MovieViewModel(id: movie.id, title: movie.title, subtitle: movie.subtitle, poster: useCase.loadImage(for: movie), rating: String(format: "%.2f", movie.voteAverage))
    }
}

fileprivate extension Movie {
    var subtitle: String {
        let genresDescription = genres.map({ $0.description }).joined(separator: ", ")
        return "\(releaseYear) | \(genresDescription)"
    }
    var releaseYear: Int {
        let date = releaseDate.flatMap { Movie.dateFormatter.date(from: $0) } ?? Date()
        return Calendar.current.component(.year, from: date)
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
