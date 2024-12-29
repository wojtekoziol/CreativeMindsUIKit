//
//  HomeViewController.swift
//  CreativeMindsUIKit
//
//  Created by Wojciech Kozioł on 29/12/2024.
//

import Combine
import UIKit

class PostListViewController: UIViewController {
    private let viewModel = PostListViewModel()
    private var subscribers = Set<AnyCancellable>()

    private let postListView = PostListView(frame: .zero)

    override func loadView() {
        view = postListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        postListView.delegate = self
        setupSubscribers()

        viewModel.fetchPosts()
    }

    private func setupSubscribers() {
        viewModel.$posts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] posts in
                self?.postListView.update(with: posts)
            }.store(in: &subscribers)
    }
}

extension PostListViewController: PostListViewDelegate {
    func postListViewDidPullToRefresh(_ postListView: PostListView) {
        viewModel.fetchPosts()
    }
}
