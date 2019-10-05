//
//  MovieDetailsViewModel.swift
//  TMDB
//
//  Created by Maksym Shcheglov on 02/10/2019.
//  Copyright © 2019 Maksym Shcheglov. All rights reserved.
//

import UIKit
import Combine

class MovieDetailsViewModel: MovieDetailsViewModelType {

    private let movieId: Int
    private let useCase: MoviesUseCaseType

    init(movieId: Int, useCase: MoviesUseCaseType) {
        self.movieId = movieId
        self.useCase = useCase
    }

    func transform(input: MovieDetailsViewModelInput) -> MovieDetailsViewModelOutput {
        let result = input.appear
            .flatMap({[unowned self] _ in self.useCase.movieDetails(with: self.movieId) })
            .share()
            .eraseToAnyPublisher()
        let movieDetails = result
            .flatMap({ result -> AnyPublisher<MovieViewModel, Never> in
                guard case .success(let movieDetails) = result else { return .empty() }
                let viewModel = MovieViewModelBuilder.viewModel(from: movieDetails, imageLoader: self.useCase.loadImage)
                return .just(viewModel)
            })
            .eraseToAnyPublisher()
        let loading = Publishers.Merge(input.appear.map({_ in true }), result.map({ _ in false })).eraseToAnyPublisher()
        let error = result
            .flatMap({ result -> AnyPublisher<Error, Never> in
                guard case .failure(let error) = result else { return .empty() }
                return .just(error)
            })
            .eraseToAnyPublisher()

        return MovieDetailsViewModelOutput(movieDetails: movieDetails, loading: loading, error: error)
    }
}
