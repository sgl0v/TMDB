//
//  FlowCoordinatorDependencyProviders.swift
//  TMDB
//
//  Created by Maksym Shcheglov on 02/10/2019.
//  Copyright © 2019 Maksym Shcheglov. All rights reserved.
//

import UIKit

/// The `ApplicationFlowCoordinatorDependencyProvider` protocol defines methods to satisfy external dependencies of the ApplicationFlowCoordinator
protocol ApplicationFlowCoordinatorDependencyProvider: MoviesSearchFlowCoordinatorDependencyProvider {}

protocol MoviesSearchFlowCoordinatorDependencyProvider: class {
    /// Creates UIViewController to search for a movie
    func moviesSearchNavigationController(navigator: MoviesSearchNavigator) -> UINavigationController

    // Creates UIViewController to show the details of the movie with specified identifier
    func movieDetailsController(_ movieId: Int) -> UIViewController
}
