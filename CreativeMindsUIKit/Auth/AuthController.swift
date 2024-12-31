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
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    init() {
        Task {
            for await state in SupabaseService.shared.client.auth.authStateChanges {
                isAuthenticated = state.session != nil
            }
        }
    }

    func signIn(email: String, password: String) async {
        isLoading = true
        defer { isLoading = false }
        errorMessage = nil
        do {
            let _ = try await SupabaseService.shared.client.auth.signIn(email: email, password: password)
        } catch {
            errorMessage = "Something went wrong. Please try again."
        }
    }

    func signUp(email: String, password: String) async {
        isLoading = true
        defer { isLoading = false }
        errorMessage = nil
        do {
            let _ = try await SupabaseService.shared.client.auth.signUp(email: email, password: password)
        } catch {
            errorMessage = "Something went wrong. Please try again."
        }
    }

    func signOut() async {
        try? await SupabaseService.shared.client.auth.signOut()
    }
}
