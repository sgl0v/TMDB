//
//  MoviesSearchViewModelType.swift
//  TMDB
//
//  Created by Maksym Shcheglov on 02/10/2019.
//  Copyright © 2019 Maksym Shcheglov. All rights reserved.
//

import Combine

struct MoviesSearchViewModelInput {
    // triggered when the search query is updated
    let search: AnyPublisher<String, Never>
    // triggered when the search is cancelled
    let cancelSearch: AnyPublisher<Void, Never>
    /// called when the user selected an item from the list
    let selection: AnyPublisher<Int, Never>
}

enum MoviesSearchState {
    case idle
    case loading
    case success([MovieViewModel])
    case noResults
    case failure(Error)
}

extension MoviesSearchState: Equatable {
    static func == (lhs: MoviesSearchState, rhs: MoviesSearchState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle): return true
        case (.loading, .loading): return true
        case (.success(let lhsMovies), .success(let rhsMovies)): return lhsMovies == rhsMovies
        case (.noResults, .noResults): return true
        case (.failure, .failure): return true
        default: return false
        }
    }
}

typealias MoviesSearchViewModelOuput = AnyPublisher<MoviesSearchState, Never>

protocol MoviesSearchViewModelType: class {
    /// Trandforms input state to the output state
    ///
    /// - Parameter input: input state
    /// - Returns: output state
    func transform(input: MoviesSearchViewModelInput) -> MoviesSearchViewModelOuput
}
