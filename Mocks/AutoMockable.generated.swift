// Generated using Sourcery 1.0.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import XCTest
import Combine
@testable import TMDB














class ApplicationFlowCoordinatorDependencyProviderMock: ApplicationFlowCoordinatorDependencyProvider {

    //MARK: - moviesNavigationViewController

    var moviesNavigationViewControllerNavigatorCallsCount = 0
    var moviesNavigationViewControllerNavigatorCalled: Bool {
        return moviesNavigationViewControllerNavigatorCallsCount > 0
    }
    var moviesNavigationViewControllerNavigatorReceivedNavigator: MoviesNavigator?
    var moviesNavigationViewControllerNavigatorReceivedInvocations: [MoviesNavigator] = []
    var moviesNavigationViewControllerNavigatorReturnValue: UINavigationController!
    var moviesNavigationViewControllerNavigatorClosure: ((MoviesNavigator) -> UINavigationController)?

    func moviesNavigationViewController(navigator: MoviesNavigator) -> UINavigationController {
        moviesNavigationViewControllerNavigatorCallsCount += 1
        moviesNavigationViewControllerNavigatorReceivedNavigator = navigator
        moviesNavigationViewControllerNavigatorReceivedInvocations.append(navigator)
        return moviesNavigationViewControllerNavigatorClosure.map({ $0(navigator) }) ?? moviesNavigationViewControllerNavigatorReturnValue
    }

    //MARK: - movieDetailsController

    var movieDetailsControllerCallsCount = 0
    var movieDetailsControllerCalled: Bool {
        return movieDetailsControllerCallsCount > 0
    }
    var movieDetailsControllerReceivedMovieId: Int?
    var movieDetailsControllerReceivedInvocations: [Int] = []
    var movieDetailsControllerReturnValue: UIViewController!
    var movieDetailsControllerClosure: ((Int) -> UIViewController)?

    func movieDetailsController(_ movieId: Int) -> UIViewController {
        movieDetailsControllerCallsCount += 1
        movieDetailsControllerReceivedMovieId = movieId
        movieDetailsControllerReceivedInvocations.append(movieId)
        return movieDetailsControllerClosure.map({ $0(movieId) }) ?? movieDetailsControllerReturnValue
    }



}
class CoreDataServiceTypeMock: CoreDataServiceType {

    //MARK: - fetchAll

    var fetchAllCallsCount = 0
    var fetchAllCalled: Bool {
        return fetchAllCallsCount > 0
    }
    var fetchAllReturnValue: AnyPublisher<[Movie], Error>!
    var fetchAllClosure: (() -> AnyPublisher<[Movie], Error>)?

    func fetchAll() -> AnyPublisher<[Movie], Error> {
        fetchAllCallsCount += 1
        return fetchAllClosure.map({ $0() }) ?? fetchAllReturnValue
    }

    //MARK: - fetch

    var fetchWithCallsCount = 0
    var fetchWithCalled: Bool {
        return fetchWithCallsCount > 0
    }
    var fetchWithReceivedId: Int?
    var fetchWithReceivedInvocations: [Int] = []
    var fetchWithReturnValue: AnyPublisher<Movie, Error>!
    var fetchWithClosure: ((Int) -> AnyPublisher<Movie, Error>)?

    func fetch(with id: Int) -> AnyPublisher<Movie, Error> {
        fetchWithCallsCount += 1
        fetchWithReceivedId = id
        fetchWithReceivedInvocations.append(id)
        return fetchWithClosure.map({ $0(id) }) ?? fetchWithReturnValue
    }

    //MARK: - add

    var addMoviesCallsCount = 0
    var addMoviesCalled: Bool {
        return addMoviesCallsCount > 0
    }
    var addMoviesReceivedMovies: [Movie]?
    var addMoviesReceivedInvocations: [[Movie]] = []
    var addMoviesReturnValue: AnyPublisher<[Movie], Error>!
    var addMoviesClosure: (([Movie]) -> AnyPublisher<[Movie], Error>)?

    func add(movies: [Movie]) -> AnyPublisher<[Movie], Error> {
        addMoviesCallsCount += 1
        addMoviesReceivedMovies = movies
        addMoviesReceivedInvocations.append(movies)
        return addMoviesClosure.map({ $0(movies) }) ?? addMoviesReturnValue
    }

    //MARK: - deleteAll

    var deleteAllCallsCount = 0
    var deleteAllCalled: Bool {
        return deleteAllCallsCount > 0
    }
    var deleteAllReturnValue: AnyPublisher<Void, Error>!
    var deleteAllClosure: (() -> AnyPublisher<Void, Error>)?

    func deleteAll() -> AnyPublisher<Void, Error> {
        deleteAllCallsCount += 1
        return deleteAllClosure.map({ $0() }) ?? deleteAllReturnValue
    }



}
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
class MoviesNavigatorMock: MoviesNavigator {

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

    //MARK: - loadMovies

    var loadMoviesCallsCount = 0
    var loadMoviesCalled: Bool {
        return loadMoviesCallsCount > 0
    }
    var loadMoviesReturnValue: AnyPublisher<Result<[Movie], Error>, Never>!
    var loadMoviesClosure: (() -> AnyPublisher<Result<[Movie], Error>, Never>)?

    func loadMovies() -> AnyPublisher<Result<[Movie], Error>, Never> {
        loadMoviesCallsCount += 1
        return loadMoviesClosure.map({ $0() }) ?? loadMoviesReturnValue
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
