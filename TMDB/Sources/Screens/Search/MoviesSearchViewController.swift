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
    private let selection = PassthroughSubject<Int, Never>()
    private let search = PassthroughSubject<String, Never>()
    private var movies = [MovieViewModel]()
    @IBOutlet private var loadingView: UIView!
    @IBOutlet private var tableView: UITableView!
    private lazy var alertViewController = AlertViewController(nibName: nil, bundle: nil)
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = UIColor.black
        searchController.searchBar.delegate = self
        return searchController
    }()

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

    private func configureUI() {
        definesPresentationContext = true
        title = NSLocalizedString("Movies", comment: "Top Movies")

        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 100
        tableView.registerNib(cellClass: MovieTableViewCell.self)

        navigationItem.searchController = self.searchController
        searchController.isActive = true

        add(alertViewController)
        alertViewController.showStartSearch()
    }

    private func bind(to viewModel: MoviesSearchViewModelType) {
        let input = MoviesSearchViewModelInput(search: search.eraseToAnyPublisher(), selection: selection.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)

        output.movies.sink {[unowned self] movies in
            guard !movies.isEmpty else {
                self.alertViewController.view.isHidden = false
                self.alertViewController.showNoResults()
                return
            }
            self.alertViewController.view.isHidden = true
            self.movies = movies
            self.tableView.reloadData()
        }
        .store(in: &cancellables)

        output.loading.sink(receiveValue: {[unowned self] isLoading in
            self.loadingView.isHidden = !isLoading
        }).store(in: &cancellables)

        output.error.sink(receiveValue: {[unowned self] isLoading in
            self.alertViewController.view.isHidden = false
            self.alertViewController.showDataLoadingError()
        }).store(in: &cancellables)
    }
}

extension MoviesSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search.send(searchText)
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
