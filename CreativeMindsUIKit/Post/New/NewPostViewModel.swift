//
//  NewPostViewModel.swift
//  CreativeMindsUIKit
//
//  Created by Wojciech Kozioł on 01/01/2025.
//

import Foundation

@MainActor
protocol NewPostViewModelDelegate: AnyObject {
    func didAddNewPost(_ newPost: Post?)
}

class NewPostViewModel {
    weak var delegate: NewPostViewModelDelegate?

    func publish(content: String) {
        Task {
            let newPost = Post.Create(content: content)
            do {
                let newPost: Post = try await SupabaseService.shared.client
                    .from("posts")
                    .insert(newPost)
                    .select()
                    .select("*, users!author_id(*)")
                    .single()
                    .execute()
                    .value

                await delegate?.didAddNewPost(newPost)
            } catch {
                print("Error adding post: \(error)")
                await delegate?.didAddNewPost(nil)
            }
        }
    }
}
