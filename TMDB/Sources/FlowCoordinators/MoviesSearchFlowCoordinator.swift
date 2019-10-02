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
    fileprivate let rootController: UINavigationController
    fileprivate let dependencyProvider: MoviesSearchFlowCoordinatorDependencyProvider

    init(rootController: UINavigationController, dependencyProvider: MoviesSearchFlowCoordinatorDependencyProvider) {
        self.rootController = rootController
        self.dependencyProvider = dependencyProvider
    }

    func start() {
        let searchController = self.dependencyProvider.moviesSearchController(navigator: self)
        self.rootController.setViewControllers([searchController], animated: false)
    }

}

extension MoviesSearchFlowCoordinator: MoviesSearchNavigator {

    func showDetails(forMovie movieId: String) {
        let controller = self.dependencyProvider.movieDetailsController(movieId)
        self.rootController.pushViewController(controller, animated: true)
    }

}
