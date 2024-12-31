//
//  LoginViewController.swift
//  CreativeMindsUIKit
//
//  Created by Wojciech Kozioł on 29/12/2024.
//

import Combine
import Factory
import UIKit

class LoginViewController: UIViewController {
    @Injected(\.authController) private var auth
    private var cancellables = Set<AnyCancellable>()

    private let loginView = LoginView()

    override func loadView() {
        view = loginView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        navigationController?.navigationBar.prefersLargeTitles = true

        addSubscribers()
        loginView.delegate = self
    }

    private func addSubscribers() {
        auth.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                self?.loginView.update(errorMessage: errorMessage)
            }.store(in: &cancellables)

        auth.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.loginView.update(isLoading: isLoading)
            }.store(in: &cancellables)
    }
}

// MARK: - LoginViewDelegate
extension LoginViewController: LoginViewDelegate {
    func loginViewDidTapSignIn(_ loginView: LoginView, email: String, password: String) {
        Task {
            await auth.signIn(email: email, password: password)
        }
    }
}
