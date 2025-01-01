//
//  NewPostView.swift
//  CreativeMindsUIKit
//
//  Created by Wojciech Kozioł on 31/12/2024.
//

import UIKit

protocol NewPostViewDelegate: AnyObject {
    func newPostViewDidTapPublish(_ newPostView: NewPostView, content: String)
}

class NewPostView: UIView {
    weak var delegate: NewPostViewDelegate?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create. Post. Share."
        label.font = .systemFont(ofSize: 24, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .graphite
        textView.font = .systemFont(ofSize: 17)
        // Placeholder - changed in delegate
        textView.text = "Write something..."
        textView.textColor = .lightGray
        textView.layer.cornerRadius = 8
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    private let publishButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .accent

        let button = UIButton(configuration: config)
        button.setTitle("Publish", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let hStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
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

    private func setupView() {
        backgroundColor = .systemBackground

        textView.delegate = self
        publishButton.addTarget(self, action: #selector(handlePublishTap), for: .touchUpInside)

        hStack.addArrangedSubview(textView)
        hStack.addArrangedSubview(publishButton)
        addSubview(titleLabel)
        addSubview(hStack)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            hStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            hStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            hStack.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),

            titleLabel.bottomAnchor.constraint(equalTo: textView.topAnchor, constant: -32),
            titleLabel.leftAnchor.constraint(equalTo: textView.leftAnchor),

            textView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.5),
        ])
        hStack.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }

    @objc private func handlePublishTap() {
        guard let content = textView.text else { return }
        delegate?.newPostViewDidTapPublish(self, content: content)
    }
}

extension NewPostView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .white
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write something..."
            textView.textColor = .lightGray
        }
    }
}
