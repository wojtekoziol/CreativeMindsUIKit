//
//  PostDetails.swift
//  CreativeMindsUIKit
//
//  Created by Wojciech Kozioł on 06/01/2025.
//

import UIKit

protocol PostDetailsViewDelegate: AnyObject {
    func didTapDeleteComment(_ comment: Comment)
    func didTapPostComment(with text: String)
}

class PostDetailsView: UIView {
    weak var delegate: PostDetailsViewDelegate?

    private var post: Post?

    // MARK: - Post Card
    private let vStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = .secondarySystemBackground
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

    // MARK: - Comments
    private let commentsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: DynamicHeightLayout())
        collectionView.contentInset = .init(top: 16, left: 0, bottom: 0, right: 0)
        collectionView.register(CommentsCollectionViewCell.self, forCellWithReuseIdentifier: CommentsCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private let commentTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .graphite
        textField.textColor = .white
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .send
        textField.attributedPlaceholder = NSAttributedString(
            string: "Write something here...",
            attributes: [.foregroundColor: UIColor.white]
        )
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let postCommentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: 17), forImageIn: .normal)
        button.tintColor = .accent
        button.isHidden = true
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Private functions
    private func setupView() {
        backgroundColor = .systemBackground

        commentsCollectionView.delegate = self
        commentsCollectionView.dataSource = self
        commentTextField.delegate = self
        postCommentButton.addTarget(self, action: #selector(handlePostCommentButtonTap), for: .touchUpInside)
        commentTextField.addTarget(self, action: #selector(handleCommentTextFieldChange), for: .editingChanged)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(tapGesture)

        vStack.addArrangedSubview(authorLabel)
        vStack.addArrangedSubview(contentLabel)
        addSubview(vStack)
        addSubview(commentsCollectionView)
        addSubview(commentTextField)
        addSubview(postCommentButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            vStack.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 16),
            vStack.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -16),

            commentsCollectionView.topAnchor.constraint(equalTo: vStack.bottomAnchor),
            commentsCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            commentsCollectionView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 16),
            commentsCollectionView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -16),

            commentTextField.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor, constant: -16),
            commentTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            commentTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            commentTextField.heightAnchor.constraint(equalToConstant: 50),

            postCommentButton.centerYAnchor.constraint(equalTo: commentTextField.centerYAnchor),
            postCommentButton.rightAnchor.constraint(equalTo: commentTextField.rightAnchor, constant: -16),
        ])
        vStack.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }

    @objc private func dismissKeyboard() {
        endEditing(true)
    }

    @objc private func handlePostCommentButtonTap() {
        guard let text = commentTextField.text else { return }
        delegate?.didTapPostComment(with: text)
        commentTextField.resignFirstResponder()
    }

    @MainActor
    @objc private func handleCommentTextFieldChange() {
        postCommentButton.isEnabled = commentTextField.text.isNotEmpty
    }

    // MARK: - UI Update
    @MainActor
    func update(with post: Post) {
        self.post = post        
        authorLabel.text = post.author.username.asUsername
        contentLabel.text = post.content

        commentsCollectionView.reloadData()

        commentTextField.text = nil
    }
}

extension PostDetailsView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return post?.comments.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CommentsCollectionViewCell.identifier,
                for: indexPath) as? CommentsCollectionViewCell,
              let post else {
            return UICollectionViewCell()
        }

        cell.delegate = self
        cell.configure(with: CommentsCollectionViewCellViewModel(comment: post.comments[indexPath.item]))
        return cell
    }
}

extension PostDetailsView: CommentsCollectionViewCellDelegate {
    func didTapDeleteComment(_ comment: Comment) {
        delegate?.didTapDeleteComment(comment)
    }
}

@MainActor
extension PostDetailsView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        postCommentButton.isHidden = false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        postCommentButton.isHidden = true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = commentTextField.text else { return false }
        delegate?.didTapPostComment(with: text)
        textField.resignFirstResponder()
        return true
    }
}
