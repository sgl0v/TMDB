//
//  MoviesSearchPage.swift
//  TMDBTests
//
//  Created by Maksym Shcheglov on 10/05/2020.
//  Copyright © 2020 Maksym Shcheglov. All rights reserved.
//

import XCTest
import EarlGrey

class MoviesSearchPage: Page {
    
    override func verify() {
        assertExists(AccessibilityIdentifiers.MoviesSearch.rootViewId)
    }
}

// MARK: Actions
extension MoviesSearchPage {
    
    @discardableResult
    func search(_ query: String) -> Self {
        EarlGrey
            .selectElement(with: grey_accessibilityID(AccessibilityIdentifiers.MoviesSearch.searchTextFieldId))
            .perform(grey_typeText(query))
        return dismissKeyboard()
    }
    
    @discardableResult
    func tapCell(at index: Int) -> Self {
        return performTap(withId: "\(AccessibilityIdentifiers.MoviesSearch.cellId).\(index)")
    }
}

// MARK: Assertions
extension MoviesSearchPage {
    
    @discardableResult
    func assertScreenTitle(_ text: String) -> Self {
        EarlGrey.selectElement(with: grey_text(text)).assert(grey_sufficientlyVisible())
        return self
    }
    
    @discardableResult
    func assertContentIsHidden() -> Self {
        return assertHidden(AccessibilityIdentifiers.MoviesSearch.tableViewId)
    }
    
    @discardableResult
    func assertMoviesCount(_ rowsCount: Int) -> Self {
        EarlGrey.selectElement(with: grey_accessibilityID(AccessibilityIdentifiers.MoviesSearch.tableViewId))
            .assert(createTableViewRowsAssert(rowsCount: rowsCount, inSection: 0))
        return self
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
}
