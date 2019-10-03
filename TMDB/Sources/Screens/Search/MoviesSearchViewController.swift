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
    private var posts = [Post]()
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
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "postId")
    }

    private func bind(to viewModel: MoviesSearchViewModelType) {
        let input = MoviesSearchViewModelInput(appear: appear.eraseToAnyPublisher(), disappear: disappear.eraseToAnyPublisher(), selection: selection.eraseToAnyPublisher(), search: search.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)

        output.posts.sink {[unowned self] posts in
            self.posts = posts
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
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postId") else {
            return UITableViewCell()
        }
        cell.textLabel?.text = posts[indexPath.row].title
        cell.detailTextLabel?.text = posts[indexPath.row].body
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selection.send(indexPath.row)
    }
}
