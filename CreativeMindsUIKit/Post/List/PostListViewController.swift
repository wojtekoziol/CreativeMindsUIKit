//
//  HomeViewController.swift
//  CreativeMindsUIKit
//
//  Created by Wojciech Kozioł on 29/12/2024.
//

import Combine
import Factory
import UIKit

class PostListViewController: UIViewController {
    @Injected(\.authController) private var auth
    @Injected(\.postListViewModel) private var viewModel

    private var subscribers = Set<AnyCancellable>()

    private let postListView = PostListView()

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

    func postListViewDidTapPostButton(_ postListView: PostListView) {
        let vc = NewPostViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    func postListViewDidTapProfileButton(_ postListView: PostListView) {
        Task {
            await auth.signOut()
        }
    }
}
