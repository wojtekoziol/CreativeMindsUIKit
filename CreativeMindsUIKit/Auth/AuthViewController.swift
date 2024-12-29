//
//  ViewController.swift
//  CreativeMindsUIKit
//
//  Created by Wojciech Kozioł on 29/12/2024.
//

import Combine
import Factory
import UIKit

class AuthViewController: UIViewController {
    private var subscribers = Set<AnyCancellable>()
    @Injected(\.authController) private var auth

    private var currentVC: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubscribers()
    }

    private func addSubscribers() {
        auth.$isAuthenticated
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isAuthenticated in
                self?.handleAuthChange(isAuthenticated)
            }.store(in: &subscribers)
    }

    private func handleAuthChange(_ isAuthenticated: Bool) {
        currentVC?.willMove(toParent: nil)
        currentVC?.view.removeFromSuperview()
        currentVC?.removeFromParent()

        let newVC: UIViewController
        if isAuthenticated {
            newVC = PostListViewController()
        } else {
            newVC = LoginViewController()
        }

        addChild(newVC)
        view.addSubview(newVC.view)
        newVC.view.frame = view.bounds
        newVC.didMove(toParent: self)

        currentVC = newVC
    }
}

