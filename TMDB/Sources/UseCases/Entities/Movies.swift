//
//  Movies.swift
//  TMDB
//
//  Created by Maksym Shcheglov on 05/10/2019.
//  Copyright © 2019 Maksym Shcheglov. All rights reserved.
//

import Foundation

struct Movies {
    let items: [Movie]
}

extension Movies: Decodable {

    enum CodingKeys: String, CodingKey {
        case items = "results"
    }
}
