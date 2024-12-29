//
//  AuthViewModel.swift
//  CreativeMindsUIKit
//
//  Created by Wojciech Kozioł on 29/12/2024.
//

import Combine
import Foundation

class AuthController {
    @Published private(set) var isAuthenticated = false

    init() {
        Task {
            for await state in SupabaseService.shared.client.auth.authStateChanges {
                isAuthenticated = state.session != nil
            }
        }
    }

    func signIn() async {
        let _ = try? await SupabaseService.shared.client.auth.signIn(email: "wojti@mail.com", password: "password")
    }

    func signUp() async {
        let _ = try? await SupabaseService.shared.client.auth.signUp(email: "wojti@mail.com", password: "password")
    }

    func signOut() async {
        try? await SupabaseService.shared.client.auth.signOut()
    }
}
