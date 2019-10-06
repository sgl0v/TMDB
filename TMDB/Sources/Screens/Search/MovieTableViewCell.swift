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

    private var cancellable: AnyCancellable?

    override func prepareForReuse() {
        super.prepareForReuse()
        poster.image = nil
        poster.alpha = 0.0
        cancellable?.cancel()
    }
}

extension MovieTableViewCell {
    func configure(with viewModel: MovieViewModel) {
        title.text = viewModel.title
        subtitle.text = viewModel.subtitle
        rating.text = viewModel.rating
        cancellable = viewModel.poster.sink { [unowned self] image in self.showImage(image: image) }
    }

    private func showImage(image: UIImage?) {
        self.poster.image = image
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .linear) {
            self.poster.alpha = 1.0
        }
        animator.startAnimation()
    }
}
