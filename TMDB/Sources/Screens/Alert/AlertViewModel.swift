//
//  AlertViewModel.swift
//  TMDB
//
//  Created by Maksym Shcheglov on 05/10/2019.
//  Copyright © 2019 Maksym Shcheglov. All rights reserved.
//

import Foundation
import UIKit.UIImage

struct AlertViewModel {
    let title: String
    let description: String?
    let image: UIImage

    static var noResults: AlertViewModel {
        let title = NSLocalizedString("No Results", comment: "No Results")
        let description = NSLocalizedString("Please try searching again", comment: "Please try searching again")
        let image = UIImage(named: "search") ?? UIImage()
        return AlertViewModel(title: title, description: description, image: image)
    }

    static var startSearch: AlertViewModel {
        let title = NSLocalizedString("Try searching a movie", comment: "Try searching a movie")
        let image = UIImage(named: "search") ?? UIImage()
        return AlertViewModel(title: title, description: nil, image: image)
    }

    static var dataLoadingError: AlertViewModel {
        let title = NSLocalizedString("Ops...", comment: "Ops...")
        let description = NSLocalizedString("Failed to load data!", comment: "Failed to load data!")
        let image = UIImage(named: "error") ?? UIImage()
        return AlertViewModel(title: title, description: description, image: image)
    }
}
