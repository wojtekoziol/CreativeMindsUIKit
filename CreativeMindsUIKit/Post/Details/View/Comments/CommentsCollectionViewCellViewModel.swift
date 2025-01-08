//
//  CommentsCollectionViewCellViewModel.swift
//  CreativeMindsUIKit
//
//  Created by Wojciech Kozioł on 07/01/2025.
//

import Factory
import Foundation

class CommentsCollectionViewCellViewModel {
    @Injected(\.authController) private var auth

    let comment: Comment

    init(comment: Comment) {
        self.comment = comment
    }

    var isAuthor: Bool {
        auth.userID == comment.author.id
    }
}
