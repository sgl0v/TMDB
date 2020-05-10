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

class MoviesSearchTests: XCTestCase {
    
    lazy var factory = ApplicationComponentsFactory(servicesProvider: ServicesProvider(network: networkService, imageLoader: imageLoader))
    lazy var networkService = NetworkServiceTypeMock()
    lazy var imageLoader: ImageLoaderServiceType = {
        let mock = ImageLoaderServiceTypeMock()
        mock.loadImageFromClosure = { _ in
            return Just(UIImage()).eraseToAnyPublisher()
        }
        return mock
    }()
    let moviesSearchNavigator = MoviesSearchNavigatorMock()
    
    override func setUp() {
        setupEarlGrey()
    }
    
    func test_intialState() {
        // GIVEN /WHEN
        open(viewController: factory.moviesSearchController(navigator: moviesSearchNavigator))
        
        // THEN
        EarlGrey.selectElement(with: grey_text("Movies")).assert(grey_sufficientlyVisible())
        EarlGrey
            .selectElement(with: grey_accessibilityID(AccessibilityIdentifiers.Alert.rootViewId))
            .assert(grey_sufficientlyVisible())
        EarlGrey
            .selectElement(with: grey_accessibilityID(AccessibilityIdentifiers.Alert.titleLabelId))
            .assert(grey_text("Search for a movie..."))
        EarlGrey
            .selectElement(with: grey_accessibilityID(AccessibilityIdentifiers.MoviesSearch.tableViewId))
            .assert(grey_notVisible())
    }
    
    func test_startMoviesSearch_whenTypeSearchText() {
        // GIVEN
        networkService.loadResponseFilename = "MoviesSearchResults"
        open(viewController: factory.moviesSearchController(navigator: moviesSearchNavigator))
        
        // WHEN
        EarlGrey
            .selectElement(with: grey_accessibilityID(AccessibilityIdentifiers.MoviesSearch.searchTextFieldId))
            .perform(grey_typeText("Once"))
        
        // THEN
        EarlGrey.selectElement(with: grey_accessibilityID(AccessibilityIdentifiers.MoviesSearch.tableViewId))
            .assert(createTableViewRowsAssert(rowsCount: 7, inSection: 0))
    }
    
    func test_intialState() {
        // GIVEN /WHEN
        open(viewController: factory.moviesSearchController(navigator: moviesSearchNavigator))
        
        // THEN
        Page.on(MoviesSearchPage.self)
            .assertScreenTitle("Movies")
            .assertContentIsHidden()
            .on(AlertPage.self)
            .assertTitle("Search for a movie...")
    }
    
    func test_startMoviesSearch_whenTypeSearchText2() {
        // GIVEN
        networkService.loadResponseFilename = "MoviesSearchResults"
        open(viewController: factory.moviesSearchController(navigator: moviesSearchNavigator))
        
        // WHEN
        Page.on(MoviesSearchPage.self).search("Once")
        
        // THEN
        Page.on(MoviesSearchPage.self).assertMoviesCount(7)
    }
        
    private func createTableViewRowsAssert(rowsCount: Int, inSection section: Int) -> GREYAssertion {
        return GREYAssertionBlock(name: "TableViewRowsAssert") { (element, error) -> Bool in
            guard let tableView = element as? UITableView, tableView.numberOfSections > section else {
                return false
            }
            let numberOfCells = tableView.numberOfRows(inSection: section)
            return numberOfCells == rowsCount
        }
    }
    
    private func dismissKeyboard() {
      UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
