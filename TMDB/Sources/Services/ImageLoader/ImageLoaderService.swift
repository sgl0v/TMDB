//
//  ImageLoader.swift
//  TMDB
//
//  Created by Maksym Shcheglov on 05/10/2019.
//  Copyright © 2019 Maksym Shcheglov. All rights reserved.
//

import Foundation
import UIKit.UIImage
import Combine

final class ImageLoaderService: ImageLoaderServiceType {

    // cache with raw img data
    private lazy var imageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        let MB = 1024 * 1024
        cache.totalCostLimit = 10 * MB // approx memory size that the cache can hold before it starts evicting objects
        return cache
    }()

    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        if let image = self.imageCache.object(forKey: url as AnyObject) as? UIImage {
            return .just(image)
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { (data, response) -> UIImage? in return UIImage(data: data) }
            .catch { error in return Just(nil) }
            .handleEvents(receiveOutput: {[unowned self] image in
                guard let image = image else { return }
                self.imageCache.setObject(image, forKey: url as AnyObject)
            })
            .print("Image loading \(url):")
            .eraseToAnyPublisher()
    }
}
