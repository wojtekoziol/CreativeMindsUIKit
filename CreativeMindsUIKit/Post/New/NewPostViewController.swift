//
//  NewPostViewController.swift
//  CreativeMindsUIKit
//
//  Created by Wojciech Kozioł on 31/12/2024.
//

import Factory
import UIKit

class NewPostViewController: UIViewController {
    private let viewModel = NewPostViewModel()

    private let newPostView = NewPostView()

    override func loadView() {
        view = newPostView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New post"

        viewModel.delegate = self
        newPostView.delegate = self
    }
}

extension NewPostViewController: NewPostViewDelegate, NewPostViewModelDelegate {
    func newPostViewDidTapPublish(_ newPostView: NewPostView, content: String) {
        viewModel.publish(content: content)
    }
    
    func didAddNewPost(_ newPost: PostListViewModel.Post?) {
        if let newPost {
            Container.shared.postListViewModel().insertPost(newPost)
            navigationController?.popToRootViewController(animated: true)
        } else {
            print("Error adding new post")
        }
    }
}
