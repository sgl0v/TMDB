//
//  ImageSize.swift
//  TMDB
//
//  Created by Maksym Shcheglov on 06/10/2019.
//  Copyright © 2019 Maksym Shcheglov. All rights reserved.
//

import Foundation

enum ImageSize {
    case small
    case original
    var url: URL {
        switch self {
        case .small: return ApiConstants.smallImageUrl
        case .original: return ApiConstants.originalImageUrl
        }
    }
}
