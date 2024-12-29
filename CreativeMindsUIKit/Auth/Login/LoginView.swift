//
//  LoginView.swift
//  CreativeMindsUIKit
//
//  Created by Wojciech Kozioł on 29/12/2024.
//

import UIKit

protocol LoginViewDelegate: AnyObject {
    func loginViewDidTapSignIn(_ loginView: LoginView)
}

class LoginView: UIView {
    weak var delegate: LoginViewDelegate?

    let signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .systemOrange
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupView() {
        backgroundColor = .systemBackground
        
        signInButton.addTarget(self, action: #selector(handleSignInTap), for: .touchUpInside)

        addSubview(signInButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            signInButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            signInButton.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    @objc private func handleSignInTap() {
        delegate?.loginViewDidTapSignIn(self)
    }
}
