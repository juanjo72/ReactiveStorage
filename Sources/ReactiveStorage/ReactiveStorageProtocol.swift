//
//  ReactiveStorageProtocol.swift
//  ReactiveStorage
//
//  Created by Juanjo García Villaescusa on 9/8/24.
//

import Combine

public protocol ReactiveStorageProtocol {
    func getAllElementsObservable<Entity: Identifiable>(of type: Entity.Type) -> AnyPublisher<[Entity], Never>
    func getSingleElementObservable<Entity: Identifiable>(of type: Entity.Type, id: Entity.ID) -> AnyPublisher<Entity?, Never>
    func getAllElements<Entity: Identifiable>(of type: Entity.Type) async -> [Entity]
    func getSingleElement<Entity: Identifiable>(of type: Entity.Type, id: Entity.ID) async -> Entity?
    func add<Entity: Identifiable>(_ element: Entity) async
    func add<Entity: Identifiable>(_ elements: [Entity]) async
    func removeSingleElement<Entity: Identifiable>(of type: Entity.Type, id: Entity.ID) async
    func removeAllElements<Entity: Identifiable>(of type: Entity.Type) async
}
