//
//  Genre.swift
//  TMDB
//
//  Created by Maksym Shcheglov on 05/10/2019.
//  Copyright © 2019 Maksym Shcheglov. All rights reserved.
//

import Foundation

enum Genre: Int, CustomStringConvertible, Decodable, Hashable {
    case action = 28
    case adventure = 12
    case animation = 16
    case comedy = 35
    case crime = 80
    case documentary = 99
    case drama = 18
    case family = 10751
    case fantasy = 14
    case history = 36
    case horror = 27
    case music = 10402
    case mystery = 9648
    case romance = 10749
    case scienceFiction = 878
    case tvMovie = 10770
    case thriller = 53
    case war = 10752
    case western = 37

    var description: String {
        switch self {
            case .action: return NSLocalizedString("Action", comment: "Action")
            case .adventure: return NSLocalizedString("Adventure", comment: "Adventure")
            case .animation: return NSLocalizedString("Animation", comment: "Animation")
            case .comedy: return NSLocalizedString("Comedy", comment: "Comedy")
            case .crime: return NSLocalizedString("Crime", comment: "Crime")
            case .documentary: return NSLocalizedString("Documentary", comment: "Documentary")
            case .drama: return NSLocalizedString("Drama", comment: "Drama")
            case .family: return NSLocalizedString("Family", comment: "Family")
            case .fantasy: return NSLocalizedString("Fantasy", comment: "Fantasy")
            case .history: return NSLocalizedString("History", comment: "History")
            case .horror: return NSLocalizedString("Horror", comment: "Horror")
            case .music: return NSLocalizedString("Music", comment: "Music")
            case .mystery: return NSLocalizedString("Mystery", comment: "Mystery")
            case .romance: return NSLocalizedString("Romance", comment: "Romance")
            case .scienceFiction: return NSLocalizedString("Science Fiction", comment: "Science Fiction")
            case .tvMovie: return NSLocalizedString("TV Movie", comment: "TV Movie")
            case .thriller: return NSLocalizedString("Thriller", comment: "Thriller")
            case .war: return NSLocalizedString("War", comment: "War")
            case .western: return NSLocalizedString("Western", comment: "Western")
        }
    }
}
