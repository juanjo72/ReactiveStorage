//
//  Array+replacingOcurrences.swift
//  ReactiveStorage
//
//  Created by Juanjo García Villaescusa on 9/8/24.
//

extension Array where Element: Identifiable {
    func appending(_ element: Element) -> Self {
        var mutable: [Element] = self
        mutable.append(element)
        return mutable
    }
}
