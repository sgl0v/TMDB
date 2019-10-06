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
    func searchMovies(with name: String) -> AnyPublisher<Result<[Movie], Error>, Never>

    /// Fetches details for movie with specified id
    func movieDetails(with id: Int) -> AnyPublisher<Result<Movie, Error>, Never>

    // Loads image for the given movie
    func loadImage(for movie: Movie, size: ImageSize) -> AnyPublisher<UIImage?, Never>
}

final class MoviesUseCase: MoviesUseCaseType {

    private let networkService: NetworkServiceType
    private let imageLoaderService: ImageLoaderServiceType

    init(networkService: NetworkServiceType, imageLoaderService: ImageLoaderServiceType) {
        self.networkService = networkService
        self.imageLoaderService = imageLoaderService
    }

    var popularMovies: AnyPublisher<[Movie], Error> {
        fatalError()
    }

    func searchMovies(with name: String) -> AnyPublisher<Result<[Movie], Error>, Never> {
        return networkService
            .load(Resource<Movies>.movies(query: name))
            .map({ (result: Result<Movies, NetworkError>) -> Result<[Movie], Error> in
                switch result {
                case .success(let movies): return .success(movies.items)
                case .failure(let error): return .failure(error)
                }
            })
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }

    func movieDetails(with id: Int) -> AnyPublisher<Result<Movie, Error>, Never> {
        return networkService
            .load(Resource<Movie>.details(movieId: id))
            .map({ (result: Result<Movie, NetworkError>) -> Result<Movie, Error> in
                switch result {
                case .success(let movie): return .success(movie)
                case .failure(let error): return .failure(error)
                }
            })
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }

    func loadImage(for movie: Movie, size: ImageSize) -> AnyPublisher<UIImage?, Never> {
        return Deferred<AnyPublisher<String?, Never>>
        .just(movie.poster)
        .flatMap({[unowned self] poster -> AnyPublisher<UIImage?, Never> in
            guard let poster = movie.poster else { return .just(nil) }
            let url = size.url.appendingPathComponent(poster)
            return self.imageLoaderService.loadImage(from: url)
        })
        .subscribe(on: Scheduler.backgroundWorkScheduler)
        .receive(on: Scheduler.mainScheduler)
        .eraseToAnyPublisher()
    }

}
