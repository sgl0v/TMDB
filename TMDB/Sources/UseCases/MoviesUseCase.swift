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

protocol MoviesUseCaseType: AutoMockable {

    /// Runs movies search with a query string
    func searchMovies(with name: String) -> AnyPublisher<Result<Movies, Error>, Never>

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

    func searchMovies(with name: String) -> AnyPublisher<Result<Movies, Error>, Never> {
        return networkService
            .load(Resource<Movies>.movies(query: name))
            .map { .success($0) }
            .catch { error -> AnyPublisher<Result<Movies, Error>, Never> in .just(.failure(error)) }
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }

    func movieDetails(with id: Int) -> AnyPublisher<Result<Movie, Error>, Never> {
        return networkService
            .load(Resource<Movie>.details(movieId: id))
            .map { .success($0) }
            .catch { error -> AnyPublisher<Result<Movie, Error>, Never> in .just(.failure(error)) }
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }

    func loadImage(for movie: Movie, size: ImageSize) -> AnyPublisher<UIImage?, Never> {
        guard let poster = movie.poster else { return .just(nil) }
        let url = size.url.appendingPathComponent(poster)
        return imageLoaderService.loadImage(from: url, placeholder: imageFrom(color: .gray))
    }
    
    func imageFrom(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}
