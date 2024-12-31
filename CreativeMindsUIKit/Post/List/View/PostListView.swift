//
//  PostListView.swift
//  CreativeMindsUIKit
//
//  Created by Wojciech Kozioł on 29/12/2024.
//

import UIKit

protocol PostListViewDelegate: AnyObject {
    func postListViewDidPullToRefresh(_ postListView: PostListView)
    func postListViewDidTapPostButton(_ postListView: PostListView)
    func postListViewDidTapProfileButton(_ postListView: PostListView)
}

class PostListView: UIView {
    weak var delegate: PostListViewDelegate?

    private var posts: [PostListViewModel.Post] = []

    private var appBar = PostListViewAppBar()

    private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: DynamicHeightLayout())
        collectionView.register(PostCollectionViewCell.self,
                                forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
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

        appBar.delegate = self

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(handlePullToRefresh), for: .valueChanged)

        addSubview(appBar)
        addSubview(collectionView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            appBar.topAnchor.constraint(equalTo: topAnchor),
            appBar.leftAnchor.constraint(equalTo: leftAnchor),
            appBar.rightAnchor.constraint(equalTo: rightAnchor),

            collectionView.topAnchor.constraint(equalTo: appBar.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
        ])
    }

    @objc private func handlePullToRefresh() {
        delegate?.postListViewDidPullToRefresh(self)
    }

    // MARK: - UI Update
    @MainActor
    func update(with posts: [PostListViewModel.Post]) {
        collectionView.refreshControl?.endRefreshing()
        self.posts = posts
        collectionView.reloadData()
    }
}

extension PostListView: PostListViewAppBarDelegate {
    func postListViewAppBarDidTapPostButton(_ postListViewAppBar: PostListViewAppBar) {
        delegate?.postListViewDidTapPostButton(self)
    }
    
    func postListViewAppBarDidTapProfileButton(_ postListViewAppBar: PostListViewAppBar) {
        delegate?.postListViewDidTapProfileButton(self)
    }
}

// MARK: - UICollectionView
extension PostListView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PostCollectionViewCell.identifier,
            for: indexPath) as? PostCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: posts[indexPath.item])
        return cell
    }
}

// https://medium.com/swift2go/implementing-a-dynamic-height-uicollectionviewcell-in-swift-5-bdd912acd5c8
final class DynamicHeightLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributesObjects = super.layoutAttributesForElements(in: rect)?.map{ $0.copy() } as? [UICollectionViewLayoutAttributes]
        layoutAttributesObjects?.forEach({ layoutAttributes in
            if layoutAttributes.representedElementCategory == .cell {
                if let newFrame = layoutAttributesForItem(at: layoutAttributes.indexPath)?.frame {
                    layoutAttributes.frame = newFrame
                }
            }
        })
        return layoutAttributesObjects
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else { fatalError() }
        guard let layoutAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else {
            return nil
        }

        layoutAttributes.frame.origin.x = sectionInset.left
        layoutAttributes.frame.size.width = collectionView.safeAreaLayoutGuide.layoutFrame.width - sectionInset.left - sectionInset.right
        return layoutAttributes
    }
}
