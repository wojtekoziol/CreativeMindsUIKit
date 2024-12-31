//
//  PostCollectionViewCell.swift
//  CreativeMindsUIKit
//
//  Created by Wojciech Kozioł on 29/12/2024.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    static let identifier = "PostCollectionViewCell"

    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func configure(with post: PostListViewModel.Post) {
        authorLabel.text = "@\(post.author.username)"
        contentLabel.text = post.content
    }

    private func setupCell() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 8

        contentView.addSubview(authorLabel)
        contentView.addSubview(contentLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            authorLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            authorLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),

            contentLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor),
            contentLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            contentLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
            contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
        authorLabel.setContentHuggingPriority(.required, for: .vertical)
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }
}
