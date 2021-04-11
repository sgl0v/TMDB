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

class NetworkServiceTests: XCTestCase {

    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        return URLSession(configuration: config)
    }()
    private lazy var networkService = NetworkService(session: session)
    private let resource = Resource<Movies>.movies(query: "joker")
    private lazy var moviesJsonData: Data = {
        let url = Bundle(for: NetworkServiceTests.self).url(forResource: "Movies", withExtension: "json")
        guard let resourceUrl = url, let data = try? Data(contentsOf: resourceUrl) else {
            XCTFail("Failed to create data object from string!")
            return Data()
        }
        return data
    }()
    private var cancellables: [AnyCancellable] = []

    override class func setUp() {
        URLProtocol.registerClass(URLProtocolMock.self)
    }

    func test_loadFinishedSuccessfully() {
        // Given
        var result: Result<Movies, Error>?
        let expectation = self.expectation(description: "networkServiceExpectation")
        URLProtocolMock.requestHandler = { request in
            let response = HTTPURLResponse(url: self.resource.url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, self.moviesJsonData)
        }

        // When
        networkService.load(resource)
            .map({ movies -> Result<Movies, Error> in Result.success(movies)})
            .catch({ error -> AnyPublisher<Result<Movies, Error>, Never> in .just(.failure(error)) })
            .sink(receiveValue: { value in
                result = value
                expectation.fulfill()
        }).store(in: &cancellables)

        // Then
        self.waitForExpectations(timeout: 1.0, handler: nil)
        guard case .success(let movies) = result else {
            XCTFail()
            return
        }
        XCTAssertEqual(movies.items.count, 7)
    }

    func test_loadFailedWithInternalError() {
        // Given
        var result: Result<Movies, Error>?
        let expectation = self.expectation(description: "networkServiceExpectation")
        URLProtocolMock.requestHandler = { request in
            let response = HTTPURLResponse(url: self.resource.url, statusCode: 500, httpVersion: nil, headerFields: nil)!
            return (response, Data())
        }

        // When
        networkService.load(resource)
            .map({ movies -> Result<Movies, Error> in Result.success(movies)})
            .catch({ error -> AnyPublisher<Result<Movies, Error>, Never> in .just(.failure(error)) })
            .sink(receiveValue: { value in
                result = value
                expectation.fulfill()
            }).store(in: &cancellables)

        // Then
        self.waitForExpectations(timeout: 1.0, handler: nil)
        guard case .failure(let error) = result,
            let networkError = error as? NetworkError,
            case NetworkError.dataLoadingError(500, _) = networkError else {
            XCTFail()
            return
        }
    }

    func test_loadFailedWithJsonParsingError() {
        // Given
        var result: Result<Movies, Error>?
        let expectation = self.expectation(description: "networkServiceExpectation")
        URLProtocolMock.requestHandler = { request in
            let response = HTTPURLResponse(url: self.resource.url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, Data())
        }

        // When
        networkService.load(resource)
            .map({ movies -> Result<Movies, Error> in Result.success(movies)})
            .catch({ error -> AnyPublisher<Result<Movies, Error>, Never> in .just(.failure(error)) })
            .sink(receiveValue: { value in
                result = value
                expectation.fulfill()
            }).store(in: &cancellables)

        // Then
        self.waitForExpectations(timeout: 1.0, handler: nil)
        guard case .failure(let error) = result, error is DecodingError else {
            XCTFail()
            return
        }
    }
}
