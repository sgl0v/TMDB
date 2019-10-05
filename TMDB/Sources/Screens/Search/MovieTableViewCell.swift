//
//  MovieTableViewCell.swift
//  TMDB
//
//  Created by Maksym Shcheglov on 05/10/2019.
//  Copyright © 2019 Maksym Shcheglov. All rights reserved.
//

import UIKit
import Combine

class MovieTableViewCell: UITableViewCell, NibProvidable, ReusableView {

    @IBOutlet private var title: UILabel!
    @IBOutlet private var subtitle: UILabel!
    @IBOutlet private var rating: UILabel!
    @IBOutlet private var poster: UIImageView!

    private var cancellables: [AnyCancellable] = []

    override func prepareForReuse() {
        super.prepareForReuse()
        poster.image = nil
        cancellables.forEach { $0.cancel() }
        cancellables = []
    }
}

extension MovieTableViewCell {
    func configure(with viewModel: MovieViewModel) {
        title.text = viewModel.title
        subtitle.text = viewModel.subtitle
        rating.text = viewModel.rating
        viewModel.poster
            .assign(to: \UIImageView.image, on: self.poster)
            .store(in: &cancellables)
    }
}
