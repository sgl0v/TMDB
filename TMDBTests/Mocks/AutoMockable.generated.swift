// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
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

class NetworkServiceTypeMock: NetworkServiceType {

    var loadCallsCount = 0
    var loadCalled: Bool {
        return loadCallsCount > 0
    }
    var responses = [String:Any]()

    func load<T: Decodable>(_ resource: Resource<T>) -> AnyPublisher<Result<T, NetworkError>, Never> {
        loadCallsCount += 1
        let result: Result<T, NetworkError>
        if let response = responses[resource.url.path] {
            result = .success(response as! T)
        } else {
            result = .failure(NetworkError.invalidRequest)
        }
        return Just<Result<T, NetworkError>>(result).eraseToAnyPublisher()
    }
}
