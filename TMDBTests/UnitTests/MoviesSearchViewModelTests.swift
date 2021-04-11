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

class MoviesSearchViewModelTests: XCTestCase {
    private let useCase = MoviesUseCaseTypeMock()
    private let navigator = MoviesSearchNavigatorMock()
    private var viewModel: MoviesSearchViewModel!
    private var cancellables: [AnyCancellable] = []

    override func setUp() {
        viewModel = MoviesSearchViewModel(useCase: useCase, navigator: navigator)
    }

    func test_loadData_onSearch() {
        // Given
        let search = PassthroughSubject<String, Never>()
        let input = MoviesSearchViewModelInput(appear: .just(()), search: search.eraseToAnyPublisher(), selection: .empty())
        var state: MoviesSearchState?

        let expectation = self.expectation(description: "movies")
        let movies = Movies.loadFromFile("Movies.json")
        let expectedViewModels = movies.items.map({ movie in
            return MovieViewModelBuilder.viewModel(from: movie, imageLoader: { _ in .just(UIImage()) })
        })
        useCase.searchMoviesWithReturnValue = .just(.success(movies))
        useCase.loadImageForSizeReturnValue = .just(UIImage())
        viewModel.transform(input: input).sink { value in
            guard case MoviesSearchState.success = value else { return }
            state = value
            expectation.fulfill()
        }.store(in: &cancellables)

        // When
        search.send("joker")

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(state!, .success(expectedViewModels))
    }

    func test_hasErrorState_whenDataLoadingIsFailed() {
        // Given
        let search = PassthroughSubject<String, Never>()
        let input = MoviesSearchViewModelInput(appear: .just(()), search: search.eraseToAnyPublisher(), selection: .empty())
        var state: MoviesSearchState?

        let expectation = self.expectation(description: "movies")
        useCase.searchMoviesWithReturnValue = .just(.failure(NetworkError.invalidResponse))
        useCase.loadImageForSizeReturnValue = .just(UIImage())
        viewModel.transform(input: input).sink { value in
            guard case .failure = value else { return }
            state = value
            expectation.fulfill()
        }.store(in: &cancellables)

        // When
        search.send("joker")

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(state!, .failure(NetworkError.invalidResponse))
    }

}
