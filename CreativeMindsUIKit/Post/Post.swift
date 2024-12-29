//
//  Post.swift
//  CreativeMindsUIKit
//
//  Created by Wojciech Kozioł on 29/12/2024.
//

import Foundation

struct Post: Codable, Identifiable {
    let id: UUID
    let content: String
    let created_at: Date
}

extension PostListViewModel {
    struct Post: Codable, Identifiable {
        let id: UUID
        let content: String
        let created_at: Date
        let author: User

        enum CodingKeys: String, CodingKey {
            case id
            case content
            case created_at
            case author = "users"
        }
    }

}
