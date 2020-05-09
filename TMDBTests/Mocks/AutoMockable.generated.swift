// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import XCTest
@testable import TMDB














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
