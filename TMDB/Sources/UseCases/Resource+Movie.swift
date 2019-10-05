//
//  Resource+Movie.swift
//  TMDB
//
//  Created by Maksym Shcheglov on 05/10/2019.
//  Copyright © 2019 Maksym Shcheglov. All rights reserved.
//

import Foundation

extension Resource {

    static func movies(query: String) -> Resource<Movies> {
        let url = ApiConstants.baseUrl.appendingPathComponent("/movie/popular")
        let parameters: [String : CustomStringConvertible] = [
            "api_key": ApiConstants.apiKey,
            "language": "en-US",
            "page": 1
            ]
        return Resource<Movies>(url: url, parameters: parameters)
    }

    static func details(movieId: Int) -> Resource<Movie> {
        let url = ApiConstants.baseUrl.appendingPathComponent("/movie/\(movieId)")
        let parameters: [String : CustomStringConvertible] = [
            "api_key": ApiConstants.apiKey,
            "language": "en-US"
            ]
        return Resource<Movie>(url: url, parameters: parameters)
    }
}

