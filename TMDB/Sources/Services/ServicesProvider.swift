//
//  ServicesProvider.swift
//  TMDB
//
//  Created by Maksym Shcheglov on 05/10/2019.
//  Copyright © 2019 Maksym Shcheglov. All rights reserved.
//

import Foundation

class ServicesProvider {
    let network: NetworkServiceType
    let imageLoader: ImageLoaderServiceType

    static func defaultProvider() -> ServicesProvider {
        let network = NetworkService()
        let imageLoader = ImageLoaderService()
        return ServicesProvider(network: network, imageLoader: imageLoader)
    }

    init(network: NetworkServiceType, imageLoader: ImageLoaderServiceType) {
        self.network = network
        self.imageLoader = imageLoader
    }
}
