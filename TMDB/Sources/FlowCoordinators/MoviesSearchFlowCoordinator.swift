//
//  MoviesSearchFlowCoordinator.swift
//  TMDB
//
//  Created by Maksym Shcheglov on 02/10/2019.
//  Copyright © 2019 Maksym Shcheglov. All rights reserved.
//

import UIKit

/// The `MoviesSearchFlowCoordinator` takes control over the flows on the movies search screen
class MoviesSearchFlowCoordinator: FlowCoordinator {
    fileprivate let window: UIWindow
    fileprivate var searchNavigationController: UINavigationController?
    fileprivate let dependencyProvider: MoviesSearchFlowCoordinatorDependencyProvider

    init(window: UIWindow, dependencyProvider: MoviesSearchFlowCoordinatorDependencyProvider) {
        self.window = window
        self.dependencyProvider = dependencyProvider
    }

    func start() {
        let searchNavigationController = dependencyProvider.moviesSearchNavigationController(navigator: self)
        window.rootViewController = searchNavigationController
        self.searchNavigationController = searchNavigationController
    }
}

extension MoviesSearchFlowCoordinator: MoviesSearchNavigator {

    func showDetails(forMovie movieId: Int) {
        let controller = self.dependencyProvider.movieDetailsController(movieId)
        searchNavigationController?.pushViewController(controller, animated: true)
    }

}
