//
//  MoviesSearchNavigator.swift
//  TMDB
//
//  Created by Maksym Shcheglov on 02/10/2019.
//  Copyright © 2019 Maksym Shcheglov. All rights reserved.
//

import Foundation

protocol MoviesSearchNavigator: class {
    /// Presents the movies details screen
    func showDetails(forMovie movieId: String)
}
