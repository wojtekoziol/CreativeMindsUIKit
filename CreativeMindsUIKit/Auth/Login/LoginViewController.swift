//
//  LoginViewController.swift
//  CreativeMindsUIKit
//
//  Created by Wojciech Kozioł on 29/12/2024.
//

import Factory
import UIKit

class LoginViewController: UIViewController {
    @Injected(\.authController) private var auth

    private let loginView = LoginView()

    override func loadView() {
        view = loginView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loginView.delegate = self
    }    
}

// MARK: - LoginViewDelegate
extension LoginViewController: LoginViewDelegate {
    func loginViewDidTapSignIn(_ loginView: LoginView) {
        Task {
            await auth.signIn()
        }
    }
}
