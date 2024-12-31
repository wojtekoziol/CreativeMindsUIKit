//
//  NewPostViewController.swift
//  CreativeMindsUIKit
//
//  Created by Wojciech Kozioł on 31/12/2024.
//

import UIKit

class NewPostViewController: UIViewController {
    private let newPostView = NewPostView()

    override func loadView() {
        view = newPostView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New post"
    }
}
