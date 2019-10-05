//
//  MovieDetailsViewController.swift
//  TMDB
//
//  Created by Maksym Shcheglov on 02/10/2019.
//  Copyright © 2019 Maksym Shcheglov. All rights reserved.
//

import UIKit
import Combine

class MovieDetailsViewController: UIViewController {
    @IBOutlet private var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var poster: UIImageView!
    @IBOutlet private var header: UILabel!
    @IBOutlet private var subtitle: UILabel!
    @IBOutlet private var rating: UILabel!
    @IBOutlet private var overview: UILabel!

    private let viewModel: MovieDetailsViewModelType
    private var cancellables: [AnyCancellable] = []
    private let appear = PassthroughSubject<Void, Never>()

    init(viewModel: MovieDetailsViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Not supported!")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: viewModel)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appear.send(())
    }

    private func bind(to viewModel: MovieDetailsViewModelType) {
        let input = MovieDetailsViewModelInput(appear: appear.eraseToAnyPublisher())
        
        let output = viewModel.transform(input: input)

        output.sink(receiveValue: {[unowned self] state in
            self.render(state)
        }).store(in: &cancellables)
    }

    private func render(_ state: MovieDetailsState) {
        switch state {
        case .loading:
            self.contentView.isHidden = true
            self.loadingIndicator.isHidden = false
        case .failure:
            self.contentView.isHidden = true
            self.loadingIndicator.isHidden = true
        case .success(let movieDetails):
            self.contentView.isHidden = false
            self.loadingIndicator.isHidden = true
            show(movieDetails)
        }
    }

    private func show(_ movieDetails: MovieViewModel) {
        header.text = movieDetails.title
        subtitle.text = movieDetails.subtitle
        rating.text = movieDetails.rating
        overview.text = movieDetails.overview
        movieDetails.poster
            .assign(to: \UIImageView.image, on: self.poster)
            .store(in: &cancellables)
    }
}
