//
//  CommentsTableViewCell.swift
//  CreativeMindsUIKit
//
//  Created by Wojciech Kozioł on 07/01/2025.
//

import UIKit

protocol CommentsCollectionViewCellDelegate: AnyObject {
    func didTapDeleteComment(_ comment: Comment)
}

class CommentsCollectionViewCell: UICollectionViewCell {
    static let identifier = "CommentsTableViewCell"

    weak var delegate: CommentsCollectionViewCellDelegate?

    private var viewModel: CommentsCollectionViewCellViewModel?

    private let hStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let vStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .top
        stackView.layer.cornerRadius = 8
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 8, left: 8, bottom: 8, right: 8)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

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

    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: 18), forImageIn: .normal)
        button.tintColor = .accent
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupCell() {
        deleteButton.addTarget(self, action: #selector(handleDeleteButtonTap), for: .touchUpInside)

        hStack.addArrangedSubview(vStack)
        hStack.addArrangedSubview(deleteButton)

        vStack.addArrangedSubview(authorLabel)
        vStack.addArrangedSubview(contentLabel)

        contentView.addSubview(hStack)
    }

    @objc private func handleDeleteButtonTap() {
        guard let comment = viewModel?.comment else { return }
        delegate?.didTapDeleteComment(comment)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            hStack.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            hStack.rightAnchor.constraint(equalTo: contentView.rightAnchor),

            deleteButton.topAnchor.constraint(equalTo: hStack.topAnchor),
            deleteButton.rightAnchor.constraint(equalTo: hStack.rightAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 50)
        ])
        vStack.setContentHuggingPriority(.required, for: .vertical)
    }

    @MainActor
    func configure(with viewModel: CommentsCollectionViewCellViewModel) {
        self.viewModel = viewModel
        authorLabel.text = viewModel.comment.author.username.asUsername
        contentLabel.text = viewModel.comment.content
        deleteButton.isHidden = !viewModel.isAuthor
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }
}
