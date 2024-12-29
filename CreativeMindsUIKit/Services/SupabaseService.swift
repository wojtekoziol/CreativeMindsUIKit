//
//  SupabaseService.swift
//  CreativeMindsUIKit
//
//  Created by Wojciech Kozioł on 29/12/2024.
//

import Foundation
import Supabase

class SupabaseService {
    static let shared = SupabaseService()

    let client: SupabaseClient

    private init() {
        client = SupabaseClient(
            supabaseURL: URL(string: "https://uwldurkqekyvuanxozmm.supabase.co")!,
            supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV3bGR1cmtxZWt5dnVhbnhvem1tIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzU0ODQ1MjUsImV4cCI6MjA1MTA2MDUyNX0.pwLU_OffordBTRf-EhyWRZxU3hgoKCVjbcZs29wY80w")
    }
}
