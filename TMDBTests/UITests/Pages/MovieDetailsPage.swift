//
//  MovieDetailsPage.swift
//  TMDBTests
//
//  Created by Maksym Shcheglov on 10/05/2020.
//  Copyright © 2020 Maksym Shcheglov. All rights reserved.
//

import XCTest
import EarlGrey

class MovieDetailsPage: Page {
    
    override func verify() {
        assertVisible(AccessibilityIdentifiers.MovieDetails.rootViewId)
    }
}

// MARK: Assertions
extension MovieDetailsPage {
    
    @discardableResult
    func assertTitle(_ text: String) -> Self {
        return assertLabelText(AccessibilityIdentifiers.MovieDetails.titleLabelId, text)
    }
    
    @discardableResult
    func assertSubtitle(_ text: String) -> Self {
        return assertLabelText(AccessibilityIdentifiers.MovieDetails.subtitleLabelId, text)
    }
    
    @discardableResult
    func assertDescription(_ text: String) -> Self {
        return assertLabelText(AccessibilityIdentifiers.MovieDetails.descriptionLabelId, text)
    }
    
    @discardableResult
    func assertContentIsHidden() -> Self {
        return assertHidden(AccessibilityIdentifiers.MovieDetails.contentViewId)
    }
    
    @discardableResult
    func assertLoadingIndicatorIsVisible() -> Self {
        return assertVisible(AccessibilityIdentifiers.MovieDetails.loadingIndicatorId)
    }
    
    @discardableResult
    func assertLoadingIndicatorIsHidden() -> Self {
        return assertHidden(AccessibilityIdentifiers.MovieDetails.loadingIndicatorId)
    }

}

