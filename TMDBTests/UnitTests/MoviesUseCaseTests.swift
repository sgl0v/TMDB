//
//  TMDB
//
//  Created by Maksym Shcheglov.
//  Copyright © 2021 Maksym Shcheglov. All rights reserved.
//

import Foundation
import XCTest
import Combine
@testable import TMDB

class MoviesUseCaseTests: XCTestCase {

    private let networkService = NetworkServiceTypeMock()
    private let imageLoaderService = ImageLoaderServiceTypeMock()
    private var useCase: MoviesUseCase!
    private var cancellables: [AnyCancellable] = []

    override func setUp() {
        useCase = MoviesUseCase(networkService: networkService,
                                imageLoaderService: imageLoaderService)
    }

    func test_searchMoviesSucceeds() {
        // Given
        var result: Result<Movies, Error>!
        let expectation = self.expectation(description: "movies")
        let movies = Movies.loadFromFile("Movies.json")
        networkService.responses["/3/search/movie"] = movies

        // When
        useCase.searchMovies(with: "joker").sink { value in
            result = value
            expectation.fulfill()
        }.store(in: &cancellables)

        // Then
        self.waitForExpectations(timeout: 1.0, handler: nil)
        guard case .success = result! else {
            XCTFail()
            return
        }
    }

    func test_searchMoviesFailes_onNetworkError() {
        // Given
        var result: Result<Movies, Error>!
        let expectation = self.expectation(description: "movies")
        networkService.responses["/3/search/movie"] = NetworkError.invalidResponse

        // When
        useCase.searchMovies(with: "joker").sink { value in
            result = value
            expectation.fulfill()
        }.store(in: &cancellables)

        // Then
        self.waitForExpectations(timeout: 1.0, handler: nil)
        guard case .failure = result! else {
            XCTFail()
            return
        }
    }

    func test_loadsImageFromNetwork() {
        // Given
        let movies = Movies.loadFromFile("Movies.json")
        let movie = movies.items.first!
        var result: UIImage?
        let expectation = self.expectation(description: "loadImage")
        imageLoaderService.loadImageFromReturnValue = .just(UIImage())

        // When
        useCase.loadImage(for: movie, size: .small).sink { value in
            result = value
            expectation.fulfill()
        }.store(in: &cancellables)

        // Then
        self.waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNotNil(result)
    }
}
