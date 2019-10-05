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
    private let cancelSearch = PassthroughSubject<Void, Never>()
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
        let input = MoviesSearchViewModelInput(search: search.eraseToAnyPublisher(),
                                               cancelSearch: cancelSearch.eraseToAnyPublisher(),
                                               selection: selection.eraseToAnyPublisher())

        let output = viewModel.transform(input: input)

        output.sink(receiveValue: {[unowned self] state in
            self.render(state)
        }).store(in: &cancellables)
    }

    private func render(_ state: MoviesSearchState) {
        switch state {
        case .idle:
            self.alertViewController.view.isHidden = false
            self.alertViewController.showStartSearch()
            self.loadingView.isHidden = true
        case .loading:
            self.alertViewController.view.isHidden = true
            self.loadingView.isHidden = false
        case .noResults:
            self.alertViewController.view.isHidden = false
            self.alertViewController.showNoResults()
            self.loadingView.isHidden = true
        case .failure:
            self.alertViewController.view.isHidden = false
            self.alertViewController.showDataLoadingError()
            self.loadingView.isHidden = true
        case .success(let movies):
            self.alertViewController.view.isHidden = true
            self.loadingView.isHidden = true
            self.movies = movies
            self.tableView.reloadData()
        }
    }
}

extension MoviesSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search.send(searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        cancelSearch.send(())
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
        selection.send(movies[indexPath.row].id)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchController.searchBar.resignFirstResponder()
    }
}
