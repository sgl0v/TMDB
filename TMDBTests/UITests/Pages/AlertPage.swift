//
//  AlertPage.swift
//  TMDBTests
//
//  Created by Maksym Shcheglov on 10/05/2020.
//  Copyright © 2020 Maksym Shcheglov. All rights reserved.
//

import XCTest
import EarlGrey

class AlertPage: Page {
    
    override func verify() {
        assertVisible(AccessibilityIdentifiers.Alert.rootViewId)
    }
    
    @discardableResult
    func assertTitle(_ text: String) -> Self {
        return assertLabelText(AccessibilityIdentifiers.Alert.titleLabelId, text)
    }
    
    @discardableResult
    func assertDescription(_ text: String) -> Self {
        return assertLabelText(AccessibilityIdentifiers.Alert.descriptionLabelId, text)
    }

}
