//
//  PostListViewAppBar.swift
//  CreativeMindsUIKit
//
//  Created by Wojciech Kozioł on 31/12/2024.
//

import UIKit

protocol PostListViewAppBarDelegate: AnyObject {
    func postListViewAppBarDidTapPostButton(_ postListViewAppBar: PostListViewAppBar)
    func postListViewAppBarDidTapProfileButton(_ postListViewAppBar: PostListViewAppBar)
}

class PostListViewAppBar: UIView {
    weak var delegate: PostListViewAppBarDelegate?

    private let appLabel: UILabel = {
        let label = UILabel()
        label.text = "Creative Minds"
        label.font = .systemFont(ofSize: 20, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let postButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .accent
        configuration.title = "Post"
        configuration.contentInsets = .init(top: 4, leading: 16, bottom: 4, trailing: 16)

        let button = UIButton(configuration: configuration)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let profileButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "person.crop.circle.fill"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: 24), forImageIn: .normal)
        button.tintColor = .accent
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
        translatesAutoresizingMaskIntoConstraints = false

        postButton.addTarget(self, action: #selector(handlePostButtonTap), for: .touchUpInside)
        profileButton.addTarget(self, action: #selector(handleProfileButtonTap), for: .touchUpInside)

        addSubview(appLabel)
        addSubview(postButton)
        addSubview(profileButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            bottomAnchor.constraint(equalTo: appLabel.bottomAnchor, constant: 16),

            appLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            appLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),

            postButton.centerYAnchor.constraint(equalTo: profileButton.centerYAnchor),
            postButton.rightAnchor.constraint(equalTo: profileButton.leftAnchor, constant: -8),

            profileButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            profileButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
        ])
    }

    @objc private func handlePostButtonTap() {
        delegate?.postListViewAppBarDidTapPostButton(self)
    }

    @objc private func handleProfileButtonTap() {
        delegate?.postListViewAppBarDidTapProfileButton(self)
    }
}
