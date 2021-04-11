// Generated using Sourcery 1.0.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import XCTest
import Combine
@testable import TMDB














class ImageLoaderServiceTypeMock: ImageLoaderServiceType {

    //MARK: - loadImage

    var loadImageFromCallsCount = 0
    var loadImageFromCalled: Bool {
        return loadImageFromCallsCount > 0
    }
    var loadImageFromReceivedUrl: URL?
    var loadImageFromReceivedInvocations: [URL] = []
    var loadImageFromReturnValue: AnyPublisher<UIImage?, Never>!
    var loadImageFromClosure: ((URL) -> AnyPublisher<UIImage?, Never>)?

    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        loadImageFromCallsCount += 1
        loadImageFromReceivedUrl = url
        loadImageFromReceivedInvocations.append(url)
        return loadImageFromClosure.map({ $0(url) }) ?? loadImageFromReturnValue
    }



}
class MoviesSearchNavigatorMock: MoviesSearchNavigator {

    //MARK: - showDetails

    var showDetailsForMovieCallsCount = 0
    var showDetailsForMovieCalled: Bool {
        return showDetailsForMovieCallsCount > 0
    }
    var showDetailsForMovieReceivedMovieId: Int?
    var showDetailsForMovieReceivedInvocations: [Int] = []
    var showDetailsForMovieClosure: ((Int) -> Void)?

    func showDetails(forMovie movieId: Int) {
        showDetailsForMovieCallsCount += 1
        showDetailsForMovieReceivedMovieId = movieId
        showDetailsForMovieReceivedInvocations.append(movieId)
        showDetailsForMovieClosure?(movieId)
    }



}
class MoviesUseCaseTypeMock: MoviesUseCaseType {

    //MARK: - searchMovies

    var searchMoviesWithCallsCount = 0
    var searchMoviesWithCalled: Bool {
        return searchMoviesWithCallsCount > 0
    }
    var searchMoviesWithReceivedName: String?
    var searchMoviesWithReceivedInvocations: [String] = []
    var searchMoviesWithReturnValue: AnyPublisher<Result<Movies, Error>, Never>!
    var searchMoviesWithClosure: ((String) -> AnyPublisher<Result<Movies, Error>, Never>)?

    func searchMovies(with name: String) -> AnyPublisher<Result<Movies, Error>, Never> {
        searchMoviesWithCallsCount += 1
        searchMoviesWithReceivedName = name
        searchMoviesWithReceivedInvocations.append(name)
        return searchMoviesWithClosure.map({ $0(name) }) ?? searchMoviesWithReturnValue
    }

    //MARK: - movieDetails

    var movieDetailsWithCallsCount = 0
    var movieDetailsWithCalled: Bool {
        return movieDetailsWithCallsCount > 0
    }
    var movieDetailsWithReceivedId: Int?
    var movieDetailsWithReceivedInvocations: [Int] = []
    var movieDetailsWithReturnValue: AnyPublisher<Result<Movie, Error>, Never>!
    var movieDetailsWithClosure: ((Int) -> AnyPublisher<Result<Movie, Error>, Never>)?

    func movieDetails(with id: Int) -> AnyPublisher<Result<Movie, Error>, Never> {
        movieDetailsWithCallsCount += 1
        movieDetailsWithReceivedId = id
        movieDetailsWithReceivedInvocations.append(id)
        return movieDetailsWithClosure.map({ $0(id) }) ?? movieDetailsWithReturnValue
    }

    //MARK: - loadImage

    var loadImageForSizeCallsCount = 0
    var loadImageForSizeCalled: Bool {
        return loadImageForSizeCallsCount > 0
    }
    var loadImageForSizeReceivedArguments: (movie: Movie, size: ImageSize)?
    var loadImageForSizeReceivedInvocations: [(movie: Movie, size: ImageSize)] = []
    var loadImageForSizeReturnValue: AnyPublisher<UIImage?, Never>!
    var loadImageForSizeClosure: ((Movie, ImageSize) -> AnyPublisher<UIImage?, Never>)?

    func loadImage(for movie: Movie, size: ImageSize) -> AnyPublisher<UIImage?, Never> {
        loadImageForSizeCallsCount += 1
        loadImageForSizeReceivedArguments = (movie: movie, size: size)
        loadImageForSizeReceivedInvocations.append((movie: movie, size: size))
        return loadImageForSizeClosure.map({ $0(movie, size) }) ?? loadImageForSizeReturnValue
    }



}

class NetworkServiceTypeMock: NetworkServiceType {

    var loadCallsCount = 0
    var loadCalled: Bool {
        return loadCallsCount > 0
    }
    var responses = [String:Any]()

    func load<T>(_ resource: Resource<T>) -> AnyPublisher<T, Error> {
        if let response = responses[resource.url.path] as? T {
            return .just(response)
        } else if let error = responses[resource.url.path] as? NetworkError {
            return .fail(error)
        } else {
            return .fail(NetworkError.invalidRequest)
        }
    }
}

class ApplicationFlowCoordinatorDependencyProviderMock: ApplicationFlowCoordinatorDependencyProvider {

    var moviesSearchNavigationControllerReturnValue: UINavigationController?
    func moviesSearchNavigationController(navigator: MoviesSearchNavigator) -> UINavigationController {
        return moviesSearchNavigationControllerReturnValue!
    }

    var movieDetailsControllerReturnValue: UIViewController?
    func movieDetailsController(_ movieId: Int) -> UIViewController {
        return movieDetailsControllerReturnValue!
    }
}
