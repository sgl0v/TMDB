//
//  TMDBTests.swift
//  TMDBTests
//
//  Created by Maksym Shcheglov on 08/05/2020.
//  Copyright © 2020 Maksym Shcheglov. All rights reserved.
//

import XCTest
import EarlGrey
import Combine
@testable import TMDB

class MoviesSearchTests: TMDBTestCase {
    
    let moviesSearchNavigator = MoviesSearchNavigatorMock()
    
    func test_intialState() {
        // GIVEN /WHEN
        open(viewController: factory.moviesSearchNavigationController(navigator: moviesSearchNavigator))
        
        // THEN
        Page.on(MoviesSearchPage.self)
            .assertScreenTitle("Movies")
            .assertContentIsHidden()
            .on(AlertPage.self)
            .assertTitle("Search for a movie...")
    }
    
    func test_startMoviesSearch_whenTypeSearchText() {
        // GIVEN
        let movies = Movies.loadFromFile("Movies.json")
        networkService.responses["/3/search/movie"] = movies
        open(viewController: factory.moviesSearchNavigationController(navigator: moviesSearchNavigator))
        
        // WHEN
        Page.on(MoviesSearchPage.self).search("jok")
        
        // THEN
        Page.on(MoviesSearchPage.self).assertMoviesCount(movies.items.count)
    }
    
    func test_showError_whenNoResultsFound() {
        // GIVEN
        networkService.responses["/3/search/movie"] = Movies(items: [])
        open(viewController: factory.moviesSearchNavigationController(navigator: moviesSearchNavigator))
        
        // WHEN
        Page.on(MoviesSearchPage.self).search("jok")
        
        // THEN
        Page.on(MoviesSearchPage.self)
            .assertContentIsHidden()
            .on(AlertPage.self)
            .assertTitle("No movies found!")
            .assertDescription("Try searching again...")
    }
    
    func test_showError_whenDataLoadingFailed() {
        // GIVEN
        open(viewController: factory.moviesSearchNavigationController(navigator: moviesSearchNavigator))
        
        // WHEN
        Page.on(MoviesSearchPage.self).search("jok")
        
        // THEN
        Page.on(MoviesSearchPage.self)
            .assertContentIsHidden()
            .on(AlertPage.self)
            .assertTitle("Can't load search results!")
            .assertDescription("Something went wrong. Try searching again...")
    }
    
    func test_showDetails_whenTapOnItem() {
        // GIVEN
        let movies = Movies.loadFromFile("Movies.json")
        networkService.responses["/3/search/movie"] = movies
        open(viewController: factory.moviesSearchNavigationController(navigator: moviesSearchNavigator))
        
        // WHEN
        Page.on(MoviesSearchPage.self)
            .search("jok")
            .tapCell(at: 0)
        
        // THEN
        XCTAssertTrue(moviesSearchNavigator.showDetailsForMovieCalled)
    }

}
