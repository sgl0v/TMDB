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

    // Loads image for the given URL
    func loadImage(for url: URL) -> AnyPublisher<UIImage, Error>
}

class MoviesUseCase: MoviesUseCaseType {

    enum ApiError: Swift.Error {
        case invalidRequest
        case invalidResponse
        case networkError(statusCode: Int, data: Data)
        case jsonDecodingError(error: Error)
    }

    var popularMovies: AnyPublisher<[Movie], Error> {
        fatalError()
    }

    func loadImage(for url: URL) -> AnyPublisher<UIImage, Error> {
        fatalError()
    }

    func searchMovies(with name: String) -> AnyPublisher<Result<[Movie], Error>, Never> {
        let requestPublisher: AnyPublisher<Result<[Movie], Error>, Never> = URLSession.shared.dataTaskPublisher(for: URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=181af7fcab50e40fabe2d10cc8b90e37&language=en-US&page=1")!)
            .mapError { _ in ApiError.invalidRequest }
            .print()
            .flatMap { data, response -> AnyPublisher<Data, Error> in
                guard let response = response as? HTTPURLResponse else {
                    return .fail(ApiError.invalidResponse)
                }

                guard 200..<300 ~= response.statusCode else {
                    return .fail(ApiError.networkError(statusCode: response.statusCode, data: data))
                }

                return .just(data)
            }
            .decode(type: Movies.self, decoder: jsonDecoder)
        .map { Result<[Movie], Error>.success($0.items) }
        .catch ({ error -> AnyPublisher<Result<[Movie], Error>, Never> in
            print(error)
            return .just(.failure(ApiError.jsonDecodingError(error: error)))
        })
        .eraseToAnyPublisher()
        return requestPublisher.eraseToAnyPublisher()
    }

    private lazy var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(MoviesUseCase.dateFormatter)
        return decoder
    }()

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyy-MM-dd"
        return formatter
    }()

}
