//
//  PostListViewModel.swift
//  CreativeMindsUIKit
//
//  Created by Wojciech Kozioł on 29/12/2024.
//

import Foundation

class PostListViewModel {
    @Published private(set) var posts: [Post] = []

    func fetchPosts() {
        Task {
            do {
                posts = try await SupabaseService.shared.client
                    .from("posts")
                    .select("""
                        *,
                        author:users!posts_author_id_fkey(*),
                        comments(
                            *,
                            author:users!comments_author_id_fkey(*)
                        )
                    """)
                    .execute()
                    .value
            } catch {
                print("Error fetching posts: \(error)")
            }
        }
    }

    func insertPost(_ newPost: Post) {
        posts.insert(newPost, at: 0)
    }
}
