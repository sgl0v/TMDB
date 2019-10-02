//
//  MoviesSearchViewController.swift
//  TMDB
//
//  Created by Maksym Shcheglov on 02/10/2019.
//  Copyright © 2019 Maksym Shcheglov. All rights reserved.
//

import UIKit
import Combine

class MoviesSearchViewController : UITableViewController {

    private var cancellables: [AnyCancellable] = []
    private let viewModel: MoviesSearchViewModelType
    private let appear = PassthroughSubject<Void, Never>()
    private let disappear = PassthroughSubject<Void, Never>()
    private let selection = PassthroughSubject<Int, Never>()
    private let search = PassthroughSubject<String, Never>()
    private var posts = [Post]()

    init(viewModel: MoviesSearchViewModelType) {
        self.viewModel = viewModel
        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError("Not supported!")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "postId")
        let input = MoviesSearchViewModelInput(appear: appear.eraseToAnyPublisher(), disappear: disappear.eraseToAnyPublisher(), selection: selection.eraseToAnyPublisher(), search: search.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)
        output.posts.sink {[unowned self] posts in
            self.posts = posts
            self.tableView.reloadData()
        }
        .store(in: &cancellables)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appear.send(())
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disappear.send(())
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postId") else {
            return UITableViewCell()
        }
        cell.textLabel?.text = posts[indexPath.row].title
        cell.detailTextLabel?.text = posts[indexPath.row].body
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selection.send(indexPath.row)
    }
}
