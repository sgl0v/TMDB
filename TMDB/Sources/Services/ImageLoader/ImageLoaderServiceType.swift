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

protocol ImageLoaderServiceType: AnyObject, AutoMockable {
    func loadImage(from url: URL, placeholder: UIImage?) -> AnyPublisher<UIImage?, Never>
}
