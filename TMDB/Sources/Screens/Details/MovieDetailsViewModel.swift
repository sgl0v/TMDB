//
//  MovieDetailsViewModel.swift
//  TMDB
//
//  Created by Maksym Shcheglov on 02/10/2019.
//  Copyright © 2019 Maksym Shcheglov. All rights reserved.
//

import UIKit

class MovieDetailsViewModel: MovieDetailsViewModelType {

    private let useCase: MoviesUseCaseType

    init(useCase: MoviesUseCaseType) {
        self.useCase = useCase
    }

    func transform(input: MovieDetailsViewModelInput) -> MovieDetailsViewModelOutput {
        return MovieDetailsViewModelOutput(post: .empty(), error: .empty())
    }
}
