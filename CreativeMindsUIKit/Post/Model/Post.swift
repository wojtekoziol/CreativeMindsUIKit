//
//  Post.swift
//  CreativeMindsUIKit
//
//  Created by Wojciech Kozioł on 29/12/2024.
//

import Foundation

struct Post: Decodable, Identifiable {
    let id: UUID
    let content: String
    let created_at: Date
    let author: User
    let comments: [Comment]
}

extension Post {
    struct Create: Encodable {
        let content: String
    }
}
