//
//  MoviesSearchViewModelType.swift
//  TMDB
//
//  Created by Maksym Shcheglov on 02/10/2019.
//  Copyright © 2019 Maksym Shcheglov. All rights reserved.
//

import Combine

struct MoviesSearchViewModelInput {
    /// called when a screen becomes visible
    let appear: AnyPublisher<Void, Never>
    /// called when a screen becomes hidden
    let disappear: AnyPublisher<Void, Never>
    /// called when the user selected an item from the list
    let selection: AnyPublisher<Int, Never>
    // triggered when the search query is updated
    let search: AnyPublisher<String, Never>
}

struct MoviesSearchViewModelOuput {
    // Movies
    let movies: AnyPublisher<[MovieViewModel], Never>
    // Emits when the content is loading
    let loading: AnyPublisher<Bool, Never>
    /// Emits when a signup error has occurred and a message should be displayed.
    let error: AnyPublisher<Error, Never>
}

protocol MoviesSearchViewModelType: class {
    /// Trandforms input state to the output state
    ///
    /// - Parameter input: input state
    /// - Returns: output state
    func transform(input: MoviesSearchViewModelInput) -> MoviesSearchViewModelOuput
}
