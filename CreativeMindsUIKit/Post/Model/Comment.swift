//
//  Comment.swift
//  CreativeMindsUIKit
//
//  Created by Wojciech Kozioł on 08/01/2025.
//

import Foundation

struct Comment: Decodable, Identifiable {
    let id: UUID
    let created_at: Date
    let author: User
    let content: String
}

extension Comment {
    struct Create: Encodable {
        let content: String
        let post_id: UUID
    }
}
