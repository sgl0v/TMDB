//
//  MovieViewModelBuilder.swift
//  TMDB
//
//  Created by Maksym Shcheglov on 05/10/2019.
//  Copyright © 2019 Maksym Shcheglov. All rights reserved.
//

import Foundation
import UIKit.UIImage
import Combine

struct MovieViewModelBuilder {
    static func viewModel(from movie: Movie, imageLoader: (Movie) -> AnyPublisher<UIImage?, Never>) -> MovieViewModel {
        return MovieViewModel(id: movie.id,
                              title: movie.title,
                              subtitle: movie.subtitle,
                              overview: movie.overview,
                              poster: imageLoader(movie),
                              rating: String(format: "%.2f", movie.voteAverage))
    }
}

fileprivate extension Movie {
    var genreNames: [String] {
        if let genreIds = genreIds {
            return genreIds.map { $0.description }
        }
        if let genres = genres {
            return genres.map { $0.name }
        }
        return []
    }
    var subtitle: String {
        let genresDescription = genreNames.joined(separator: ", ")
        return "\(releaseYear) | \(genresDescription)"
    }
    var releaseYear: Int {
        let date = releaseDate.flatMap { Movie.dateFormatter.date(from: $0) } ?? Date()
        return Calendar.current.component(.year, from: date)
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
