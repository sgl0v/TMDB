//
//  Page.swift
//  TMDBTests
//
//  Created by Maksym Shcheglov on 10/05/2020.
//  Copyright © 2020 Maksym Shcheglov. All rights reserved.
//

import XCTest
import EarlGrey

class Page {
    func verify() {
        fatalError("Override \(#function) function in a subclass!")
    }
    
    static func on<T: Page>(_ type: T.Type) -> T {
        return T().verify()
    }
    
    func on<T: Page>(_ type: T.Type) -> T {
        return Page.on(T.self)
    }
}

// MARK: Assertions
extension Page {

    @discardableResult
    func assertExists(_ accessibilityID: String) -> Self {
        EarlGrey.selectElement(with: grey_accessibilityID(accessibilityID)).assert(grey_notNil())
        return self
    }

    @discardableResult
    func assertVisible(_ accessibilityID: String) -> Self {
        EarlGrey.selectElement(with: grey_accessibilityID(accessibilityID)).assert(grey_sufficientlyVisible())
        return self
    }
    
    @discardableResult
    func assertHidden(_ accessibilityID: String) -> Self {
        EarlGrey.selectElement(with: grey_accessibilityID(accessibilityID)).assert(grey_notVisible())
        return self
    }

    @discardableResult
    func assertEnabled(_ accessibilityID: String) -> Self {
        EarlGrey.selectElement(with: grey_accessibilityID(accessibilityID)).assert(grey_enabled())
        return self
    }

    @discardableResult
    func assertDisabled(_ accessibilityID: String) -> Self {
        EarlGrey.selectElement(with: grey_accessibilityID(accessibilityID)).assert(grey_not(grey_enabled()))
        return self
    }

    @discardableResult
    func assertLabelText(_ accessibilityID: String, _ text: String) -> Self {
        EarlGrey.selectElement(with: grey_accessibilityID(accessibilityID)).assert(grey_text(text))
        return self
    }

    @discardableResult
    func assertButtonTitle(_ accessibilityID: String, _ text: String) -> Self {
        EarlGrey.selectElement(with: grey_accessibilityID(accessibilityID)).assert(grey_buttonTitle(text))
        return self
    }
}

// MARK: Actions
extension Page {
    @discardableResult
    func performTap(withId accessibilityID: String) -> Self {
        EarlGrey.selectElement(with: grey_accessibilityID(accessibilityID))
            .assert(grey_sufficientlyVisible())
            .perform(grey_tap())
        return self
    }

    @discardableResult
    func performScroll(_ accessibilityID: String, _ edge: GREYContentEdge) -> Self {
        EarlGrey.selectElement(with: grey_accessibilityID(accessibilityID)).perform(grey_scrollToContentEdge(.bottom))
        return self
    }
}
