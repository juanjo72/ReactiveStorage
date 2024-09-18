//
//  User.swift
//  
//
//  Created on 9/8/24.
//

import Foundation

struct User: Identifiable, Equatable {
    let id: UUID
    let name: String
}



extension User: CustomDebugStringConvertible {
    var debugDescription: String {
        self.id.uuidString
    }
}

extension User: Comparable {
    static func < (lhs: User, rhs: User) -> Bool {
        lhs.id.uuidString < rhs.id.uuidString
    }
}
