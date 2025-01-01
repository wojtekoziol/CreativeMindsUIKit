//
//  PostListViewModel.swift
//  CreativeMindsUIKit
//
//  Created by Wojciech Kozioł on 29/12/2024.
//

import Foundation

class PostListViewModel {
    @Published private(set) var posts: [PostListViewModel.Post] = []

    func fetchPosts() {
        Task {
            do {
                posts = try await SupabaseService.shared.client
                    .from("posts")
                    .select("*, users!author_id(*)")
                    .order(Post.CodingKeys.created_at.stringValue, ascending: false)
                    .execute()
                    .value
            } catch {
                print("Error fetching posts: \(error)")
            }
        }
    }

    func insertPost(_ newPost: PostListViewModel.Post) {
        posts.insert(newPost, at: 0)
    }
}
