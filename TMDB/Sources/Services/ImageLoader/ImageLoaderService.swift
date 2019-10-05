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
    func loadImage(with path: String) -> AnyPublisher<UIImage?, Never> {
        let url = ApiConstants.imageUrl.appendingPathComponent(path)
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data, response) -> UIImage? in return UIImage(data: data) }
            .catch { error in return Just(nil) }
            .eraseToAnyPublisher()
    }
}
