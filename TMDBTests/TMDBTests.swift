//
//  TMDBTests.swift
//  TMDBTests
//
//  Created by Maksym Shcheglov on 08/05/2020.
//  Copyright © 2020 Maksym Shcheglov. All rights reserved.
//

import XCTest
import EarlGrey
@testable import TMDB

class MoviesTests: XCTestCase {
    
    let factory = ApplicationComponentsFactory()
    let moviesSearchNavigator = MoviesSearchNavigatorMock()
    
    override func setUp() {
        setupEarlGrey()
    }
    
    func testSearch() {
        // GIVEN
        open(viewController: factory.moviesSearchController(navigator: moviesSearchNavigator))
        
        // WHEN
        EarlGrey.selectElement(with: grey_accessibilityID(AccessibilityIdentifiers.MoviesSearch.searchTextFieldId)).perform(grey_typeText("once"))
        
        // THEN
        EarlGrey.selectElement(with: grey_accessibilityID(AccessibilityIdentifiers.MoviesSearch.tableViewId))
            .assert(grey_sufficientlyVisible())
//            .assert(createTableViewRowsAssert(rowCount: 5, inSection: 0))
    }
    
    private func createTableViewRowsAssert(rowCount: Int, inSection section: Int) -> GREYAssertion {
        return GREYAssertionBlock(name: "cell count") { (element, error) -> Bool in
            guard let tableView = element as? UITableView, tableView.numberOfSections > section else {
                return false
            }
            let numberOfCells = tableView.numberOfRows(inSection: section)
            return numberOfCells == rowCount
        }
    }

    
    private func setupEarlGrey() {
        GREYConfiguration.sharedInstance().setValue(false, forConfigKey: kGREYConfigKeyAnalyticsEnabled) // Disable Google analytics tracking
        GREYConfiguration.sharedInstance().setValue(5.0, forConfigKey: kGREYConfigKeyInteractionTimeoutDuration) // use 5s timeout for any interaction
        GREYTestHelper.enableFastAnimation() // increase the speed of your tests by not having to wait on slow animations.
    }
    
    private struct OpenViewControllerFlags: OptionSet {
        let rawValue: Int
        
        static let presentModally = OpenViewControllerFlags(rawValue: 1 << 0)
        static let embedInNavigation = OpenViewControllerFlags(rawValue: 1 << 1)
        static let all: OpenViewControllerFlags = [.presentModally, .embedInNavigation]
    }
    
    private func open(viewController: UIViewController, flags: OpenViewControllerFlags = .all) {
        let viewControllerToOpen = flags.contains(.embedInNavigation) ? UINavigationController(rootViewController: viewController) : viewController
        viewControllerToOpen.modalPresentationStyle = .fullScreen
        let window = (UIApplication.shared.delegate as! FakeAppDelegate).window!
        
        if flags.contains(.presentModally) {
            window.rootViewController = UIViewController()
            window.rootViewController?.present(viewControllerToOpen, animated: false, completion: nil)
        } else {
            window.rootViewController = viewControllerToOpen
        }
    }
}


class BaseRobot {
    
}

class MoviesSearchRobot: BaseRobot {
    func open() {
        
    }
}
