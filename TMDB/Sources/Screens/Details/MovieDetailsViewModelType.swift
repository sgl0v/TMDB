//
//  MovieDetailsViewModelType.swift
//  TMDB
//
//  Created by Maksym Shcheglov on 02/10/2019.
//  Copyright © 2019 Maksym Shcheglov. All rights reserved.
//

import UIKit
import Combine

// INPUT
struct MovieDetailsViewModelInput {
    /// called when a screen becomes visible
    let appear: AnyPublisher<Void, Never>
}

// OUTPUT
struct MovieDetailsViewModelOutput {
    /// the movie to present details for
    let post: AnyPublisher<Movie, Never>
    /// Emits when a signup error has occurred and a message should be displayed.
    let error: AnyPublisher<Error, Never>
}

protocol MovieDetailsViewModelType: class {
    func transform(input: MovieDetailsViewModelInput) -> MovieDetailsViewModelOutput
}
