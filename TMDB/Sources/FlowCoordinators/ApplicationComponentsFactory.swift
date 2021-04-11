//
//  ApplicationComponentsFactory.swift
//  TMDB
//
//  Created by Maksym Shcheglov on 02/10/2019.
//  Copyright © 2019 Maksym Shcheglov. All rights reserved.
//

import UIKit

/// The ApplicationComponentsFactory takes responsibity of creating application components and establishing dependencies between them.
final class ApplicationComponentsFactory {
    fileprivate lazy var useCase: MoviesUseCaseType = MoviesUseCase(networkService: servicesProvider.network, imageLoaderService: servicesProvider.imageLoader)

    private let servicesProvider: ServicesProvider

    init(servicesProvider: ServicesProvider = ServicesProvider.defaultProvider()) {
        self.servicesProvider = servicesProvider
    }
}

extension ApplicationComponentsFactory: ApplicationFlowCoordinatorDependencyProvider {

    func moviesSearchNavigationController(navigator: MoviesSearchNavigator) -> UINavigationController {
        let viewModel = MoviesSearchViewModel(useCase: useCase, navigator: navigator)
        let moviesSearchViewController = MoviesSearchViewController(viewModel: viewModel)
        let moviesSearchNavigationController = UINavigationController(rootViewController: moviesSearchViewController)
        moviesSearchNavigationController.navigationBar.tintColor = .label
        return moviesSearchNavigationController
    }

    func movieDetailsController(_ movieId: Int) -> UIViewController {
        let viewModel = MovieDetailsViewModel(movieId: movieId, useCase: useCase)
        return MovieDetailsViewController(viewModel: viewModel)
    }
}
