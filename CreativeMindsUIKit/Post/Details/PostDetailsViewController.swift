//
//  PostDetailsViewController.swift
//  CreativeMindsUIKit
//
//  Created by Wojciech Kozioł on 06/01/2025.
//

import Combine
import UIKit

class PostDetailsViewController: UIViewController {
    private let viewModel: PostDetailsViewModel
    private var cancellables = Set<AnyCancellable>()

    private let postDetails = PostDetailsView()

    init(post: Post) {
        viewModel = PostDetailsViewModel(post: post)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func loadView() {
        view = postDetails
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Post Details"

        postDetails.delegate = self
        setupSubscribers()

        viewModel.fetch()
    }

    private func setupSubscribers() {
        viewModel.$post
            .receive(on: DispatchQueue.main)
            .sink { [weak self] post in
                self?.postDetails.update(with: post)
            }.store(in: &cancellables)
    }
}

extension PostDetailsViewController: PostDetailsViewDelegate {
    func didTapDeleteComment(_ comment: Comment) {
        let alert = UIAlertController(title: "Delete this comment?", message: "This action cannot be undone", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] action in
            if action.style == .destructive {
                self?.viewModel.deleteComment(comment)
            }
        })
        self.present(alert, animated: true, completion: nil)
    }

    func didTapPostComment(with text: String) {
        viewModel.postComment(text)
    }
}
