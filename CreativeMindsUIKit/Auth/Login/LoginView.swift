//
//  LoginView.swift
//  CreativeMindsUIKit
//
//  Created by Wojciech Kozioł on 29/12/2024.
//

import UIKit

protocol LoginViewDelegate: AnyObject {
    func loginViewDidTapSignIn(_ loginView: LoginView, email: String, password: String)
}

class LoginView: UIView {
    weak var delegate: LoginViewDelegate?

    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.placeholder = "Email"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.placeholder = "Password"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let signInButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .accent
        config.contentInsets = .init(top: 8, leading: 32, bottom: 8, trailing: 32)

        let button = UIButton(configuration: config)
        button.setTitle("Sign In", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.color = .systemBackground
        spinner.isHidden = true
        spinner.alpha = 0
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let hStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - UI Update
    @MainActor
    func update(errorMessage: String?) {
        errorLabel.isHidden = errorMessage == nil
        errorLabel.text = errorMessage
        UIView.animate(withDuration: 0.35) {
            self.errorLabel.alpha = errorMessage == nil ? 0 : 1
        }
    }

    @MainActor
    func update(isLoading: Bool) {
        signInButton.titleLabel?.isHidden = isLoading
        spinner.isHidden = !isLoading
        if isLoading {
            spinner.startAnimating()
        } else {
            spinner.stopAnimating()
        }
        UIView.animate(withDuration: 0.35) {
            self.spinner.alpha = isLoading ? 1 : 0
            self.signInButton.titleLabel?.alpha = isLoading ? 0 : 1
        }
    }

    // MARK: - Private

    private func setupView() {
        backgroundColor = .systemBackground
        
        signInButton.addTarget(self, action: #selector(handleSignInTap), for: .touchUpInside)

        hStack.addArrangedSubview(emailTextField)
        hStack.addArrangedSubview(passwordTextField)
        hStack.addArrangedSubview(signInButton)

        addSubview(hStack)
        addSubview(spinner)
        addSubview(errorLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            hStack.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
            hStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            hStack.centerYAnchor.constraint(equalTo: centerYAnchor),

            emailTextField.leftAnchor.constraint(equalTo: hStack.leftAnchor),
            emailTextField.rightAnchor.constraint(equalTo: hStack.rightAnchor),

            passwordTextField.leftAnchor.constraint(equalTo: hStack.leftAnchor),
            passwordTextField.rightAnchor.constraint(equalTo: hStack.rightAnchor),

            errorLabel.topAnchor.constraint(equalTo: hStack.bottomAnchor, constant: 8),
            errorLabel.centerXAnchor.constraint(equalTo: hStack.centerXAnchor),

            spinner.centerXAnchor.constraint(equalTo: signInButton.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: signInButton.centerYAnchor),
        ])
        hStack.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }

    @objc private func handleSignInTap() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        delegate?.loginViewDidTapSignIn(self, email: email, password: password)
    }
}
