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

    func bind(to viewModel: MovieViewModel) {
        cancelImageLoading()
        title.text = viewModel.title
        subtitle.text = viewModel.subtitle
        rating.text = viewModel.rating
      
        cancellable = viewModel.poster
          .receive(on: DispatchQueue.main)
          .assign(to: \.poster.image, on: self)
    }
  
  private func cancelImageLoading() {
      poster.image = nil
      cancellable?.cancel()
  }
}
