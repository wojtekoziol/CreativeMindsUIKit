//
//  PostDetailsViewModel.swift
//  CreativeMindsUIKit
//
//  Created by Wojciech Kozioł on 06/01/2025.
//

import Factory
import Foundation

class PostDetailsViewModel {
    @Injected(\.authController) private var auth
    @Injected(\.postListViewModel) private var postsVM
    @Published private(set) var post: Post

    init(post: Post) {
        self.post = post
    }

    func fetch() {
        Task {
            do {
                post = try await SupabaseService.shared.client
                    .from(POSTS_TABLE_NAME)
                    .select("""
                        *,
                        author:users!posts_author_id_fkey(*),
                        comments(
                            *,
                            author:users!comments_author_id_fkey(*)
                        )
                    """)
                    .eq("id", value: post.id)
                    .single()
                    .execute()
                    .value
            } catch {
                print("Error fetching post (\(post.id)) details: \(error)")
            }
        }
    }

    func postComment(_ content: String) {
        Task {
            let newComment = Comment.Create(
                content: content,
                post_id: post.id
            )
            do {
                try await SupabaseService.shared.client
                    .from(COMMENTS_TABLE_NAME)
                    .insert(newComment)
                    .execute()

                fetch()
                postsVM.fetchPosts()
            } catch {
                print("Error adding comment: \(error)")
            }
        }
    }

    func deleteComment(_ comment: Comment) {
        guard auth.userID == comment.author.id else { return }

        Task {
            do {
                try await SupabaseService.shared.client
                    .from(COMMENTS_TABLE_NAME)
                    .delete()
                    .eq("id", value: comment.id)
                    .execute()

                fetch()
                postsVM.fetchPosts()
            } catch {
                print("Error deleting comment")
            }
        }
    }
}
