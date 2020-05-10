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
    
    override var accessibilityID: String {
        return AccessibilityIdentifiers.Alert.rootViewId
    }
    
    @discardableResult
    func assertTitle(_ text: String) -> Self {
        EarlGrey
            .selectElement(with: grey_accessibilityID(AccessibilityIdentifiers.Alert.titleLabelId))
            .assert(grey_text(text))
        return self
    }
}
