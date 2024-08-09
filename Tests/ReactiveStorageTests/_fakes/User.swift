//
//  File.swift
//  
//
//  Created by Juanjo García Villaescusa on 9/8/24.
//

import Foundation

struct User: Identifiable, Equatable {
    let id: UUID
    let name: String
}

extension User {
    static func makeFake(
        id: UUID = UUID(),
        name: String = "A name"
    ) -> Self {
        User(
            id: id,
            name: name
        )
    }
}
