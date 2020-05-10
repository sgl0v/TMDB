//
//  AccessibilityIdentifiers.swift
//  TMDB
//
//  Created by Maksym Shcheglov on 09/05/2020.
//  Copyright © 2020 Maksym Shcheglov. All rights reserved.
//

import Foundation

public struct AccessibilityIdentifiers {
    
    public struct MoviesSearch {
        public static let rootViewId = "\(MoviesSearch.self).rootViewId"
        public static let tableViewId = "\(MoviesSearch.self).tableViewId"
        public static let searchTextFieldId = "\(MoviesSearch.self).searchTextFieldId"
    }
    
    public struct Alert {
        public static let rootViewId = "\(Alert.self).rootViewId"
        public static let titleLabelId = "\(Alert.self).titleLabelId"
        public static let descriptionLabelId = "\(Alert.self).descriptionLabelId"
    }
}
