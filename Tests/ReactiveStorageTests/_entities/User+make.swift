//
//  User+make.swift
//
//
//  Created on 18/9/24.
//

import Foundation

extension User {
    static func make(
        id: UUID = UUID(),
        name: String = "A name"
    ) -> Self {
        User(
            id: id,
            name: name
        )
    }
}
