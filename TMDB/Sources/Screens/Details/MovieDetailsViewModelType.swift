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
enum MovieDetailsState {
    case loading
    case success(MovieViewModel)
    case failure(Error)
}

extension MovieDetailsState: Equatable {
    static func == (lhs: MovieDetailsState, rhs: MovieDetailsState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading): return true
        case (.success(let lhsMovie), .success(let rhsMovie)): return lhsMovie == rhsMovie
        case (.failure, .failure): return true
        default: return false
        }
    }
}

typealias MovieDetailsViewModelOutput = AnyPublisher<MovieDetailsState, Never>

protocol MovieDetailsViewModelType: AnyObject {
    func transform(input: MovieDetailsViewModelInput) -> MovieDetailsViewModelOutput
}
