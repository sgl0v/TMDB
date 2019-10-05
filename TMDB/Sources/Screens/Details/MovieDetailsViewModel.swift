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
        let movieDetails = input.appear
            .flatMap({[unowned self] _ in self.useCase.movieDetails(with: self.movieId) })
            .map({ result -> MovieDetailsState in
                switch result {
                    case .success(let movie): return .success(self.viewModel(from: movie))
                    case .failure(let error): return .failure(error)
                }
            })
            .eraseToAnyPublisher()
        let loading: MovieDetailsViewModelOutput = input.appear.map({_ in .loading }).eraseToAnyPublisher()

        return Publishers.Merge(loading, movieDetails).removeDuplicates().eraseToAnyPublisher()
    }

    private func viewModel(from movie: Movie) -> MovieViewModel {
        return MovieViewModelBuilder.viewModel(from: movie, imageLoader: {[unowned self] movie in self.useCase.loadImage(for: movie) })
    }
}
