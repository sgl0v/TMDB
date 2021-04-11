//
//  MovieDetailsTests.swift
//  TMDBTests
//
//  Created by Maksym Shcheglov on 10/05/2020.
//  Copyright © 2020 Maksym Shcheglov. All rights reserved.
//

import XCTest
import EarlGrey
import Combine
@testable import TMDB

class MovieDetailsTests: TMDBTestCase {
    
    private let movieId = 475557
    
    func test_showContent_whenDataIsLoaded() {
        // GIVEN
        let movieDetails = Movie.loadFromFile("MovieDetails.json")
        networkService.responses["/3/movie/\(movieId)"] = movieDetails
        
        // WHEN
        open(viewController: factory.movieDetailsController(movieId), flags: .embedInNavigation)
        
        // THEN
        Page.on(MovieDetailsPage.self)
            .assertTitle(movieDetails.title)
            .assertSubtitle(movieDetails.subtitle)
            .assertDescription(movieDetails.overview)
    }
    
    func test_showError_whenDataLoadingFailed() {
        // GIVEN / WHEN
        open(viewController: factory.movieDetailsController(movieId), flags: .embedInNavigation)
        
        
        // THEN
        Page.on(MovieDetailsPage.self)
            .assertContentIsHidden()
            .assertLoadingIndicatorIsHidden()
    }
}
