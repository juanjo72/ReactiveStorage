//
//  Array+replacingOcurrences.swift
//  ReactiveStorage
//
//  Created by Juanjo García Villaescusa on 9/8/24.
//

extension Array where Element: Identifiable {
    func replacingOcurrences(of element: Element) -> Self {
        var updated = self
        self.enumerated()
            .filter { $0.element.id == element.id }
            .forEach { updated[$0.offset] = element }
        return updated
    }
}
