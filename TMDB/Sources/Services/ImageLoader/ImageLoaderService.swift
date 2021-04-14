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
    
    private let cache: ImageCacheType = ImageCache()
    
    func loadImage(from url: URL, placeholder: UIImage? = nil) -> AnyPublisher<UIImage?, Never> {
        if let image = cache.image(for: url) {
            return .just(image)
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> UIImage in
                guard let image = UIImage(data: data) else {
                    throw NSError(domain: "", code: 1, userInfo: nil)
                }
                
                self.cache.insertImage(image, for: url)
                return image
            }
            .replaceError(with: placeholder)
            .eraseToAnyPublisher()
    }
}
