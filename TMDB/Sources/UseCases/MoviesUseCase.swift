//
//  MoviesUseCase.swift
//  TMDB
//
//  Created by Maksym Shcheglov on 05/10/2019.
//  Copyright © 2019 Maksym Shcheglov. All rights reserved.
//

import Foundation
import Combine
import UIKit.UIImage

protocol MoviesUseCaseType {

    /// The sequence of popular movies
    var popularMovies: AnyPublisher<[Movie], Error> { get }

    /// Runs movies search with a query string
    func search(with query: String) -> AnyPublisher<[Movie], Error>

    // Loads image for the given URL
    func loadImage(for url: URL) -> AnyPublisher<UIImage, Error>
}

class MoviesUseCase {

}
