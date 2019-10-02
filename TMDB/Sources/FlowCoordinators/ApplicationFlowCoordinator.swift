//
//  ApplicationFlowCoordinator.swift
//  TMDB
//
//  Created by Maksym Shcheglov on 02/10/2019.
//  Copyright © 2019 Maksym Shcheglov. All rights reserved.
//

import UIKit

/// The application flow coordinator. Takes responsibility about coordinating view controllers and driving the flow
class ApplicationFlowCoordinator: FlowCoordinator {

    typealias DependencyProvider = ApplicationFlowCoordinatorDependencyProvider & MoviesSearchFlowCoordinatorDependencyProvider

    private let window: UIWindow
    private let dependencyProvider: DependencyProvider
    private var childCoordinators = [FlowCoordinator]()

    init(window: UIWindow, dependencyProvider: DependencyProvider) {
        self.window = window
        self.dependencyProvider = dependencyProvider
    }

    /// Creates all necessary dependencies and starts the flow
    func start() {

        let searchNavigationController = UINavigationController()
        searchNavigationController.navigationBar.tintColor = UIColor.black

        self.window.rootViewController = searchNavigationController

        let searchFlowCoordinator = MoviesSearchFlowCoordinator(rootController: searchNavigationController, dependencyProvider: self.dependencyProvider)
        searchFlowCoordinator.start()

        self.childCoordinators = [searchFlowCoordinator]
    }

}
