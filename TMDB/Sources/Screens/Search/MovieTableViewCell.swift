//
//  MovieTableViewCell.swift
//  TMDB
//
//  Created by Maksym Shcheglov on 05/10/2019.
//  Copyright © 2019 Maksym Shcheglov. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell, NibProvidable, ReusableView {

    @IBOutlet private var title: UILabel!
    @IBOutlet private var overview: UILabel!
    @IBOutlet private var rating: UILabel!
}

extension MovieTableViewCell {
    func configure(with movie: Movie) {
        title.text = movie.title
        overview.text = movie.overview
        rating.text = String(format: "%.2f", movie.voteAverage)
    }
}
