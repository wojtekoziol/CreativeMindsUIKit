//
//  Extensions.swift
//  CreativeMindsUIKit
//
//  Created by Wojciech Kozioł on 31/12/2024.
//

import Foundation

extension String? {
    var isNotEmpty: Bool {
        !(self?.isEmpty ?? true)
    }
}

extension String {
    var asUsername: String {
        "@\(self)"
    }
}
