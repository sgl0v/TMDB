//
//  ImageLoaderServiceType.swift
//  TMDB
//
//  Created by Maksym Shcheglov on 05/10/2019.
//  Copyright © 2019 Maksym Shcheglov. All rights reserved.
//

import Foundation
import UIKit.UIImage
import Combine

protocol ImageLoaderServiceType: class {
    func loadImage(with path: String) -> AnyPublisher<UIImage?, Never>
}
