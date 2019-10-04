//
//  MoviesSearchViewController.swift
//  TMDB
//
//  Created by Maksym Shcheglov on 02/10/2019.
//  Copyright © 2019 Maksym Shcheglov. All rights reserved.
//

import UIKit
import Combine

class MoviesSearchViewController : UIViewController {

    private var cancellables: [AnyCancellable] = []
    private let viewModel: MoviesSearchViewModelType
    private let appear = PassthroughSubject<Void, Never>()
    private let disappear = PassthroughSubject<Void, Never>()
    private let selection = PassthroughSubject<Int, Never>()
    private let search = PassthroughSubject<String, Never>()
    private var movies = [Movie]()
    @IBOutlet private var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private var tableView: UITableView!

    init(viewModel: MoviesSearchViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Not supported!")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind(to: viewModel)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appear.send(())
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disappear.send(())
    }

    private func configureUI() {
        definesPresentationContext = true
        title = NSLocalizedString("Movies", comment: "Top Movies")
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 100
        tableView.registerNib(cellClass: MovieTableViewCell.self)
    }

    private func bind(to viewModel: MoviesSearchViewModelType) {
        let input = MoviesSearchViewModelInput(appear: appear.eraseToAnyPublisher(), disappear: disappear.eraseToAnyPublisher(), selection: selection.eraseToAnyPublisher(), search: search.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)

        output.movies.sink {[unowned self] movies in
            self.movies = movies
            self.tableView.reloadData()
        }
        .store(in: &cancellables)

        output.loading.sink(receiveValue: {[unowned self] isLoading in
            self.tableView.isHidden = isLoading
            self.loadingIndicator.isHidden = !isLoading
        }).store(in: &cancellables)
    }
}

extension MoviesSearchViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withClass: MovieTableViewCell.self) else {
            assertionFailure("Failed to dequeue \(MovieTableViewCell.self)!")
            return UITableViewCell()
        }
        cell.configure(with: movies[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selection.send(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
