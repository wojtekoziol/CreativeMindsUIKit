//
//  App+Injected.swift
//  CreativeMindsUIKit
//
//  Created by Wojciech Kozioł on 29/12/2024.
//

import Factory
import Foundation

extension SharedContainer {
    var authController: Factory<AuthController> {
        self { AuthController() }
            .shared
    }

    var postListViewModel: Factory<PostListViewModel> {
        self { PostListViewModel() }
            .singleton
    }
}
