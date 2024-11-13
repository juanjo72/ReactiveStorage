//
//  ReactiveStorageProtocol.swift
//  ReactiveStorage
//
//  Created on 9/8/24.
//

import Combine

public typealias EntityType = Identifiable & Equatable & Sendable

public protocol ReactiveStorageProtocol: Sendable {
    func getAllElementsObservable<Entity: EntityType>(of type: Entity.Type) -> AnyPublisher<[Entity], Never>
    func getSingleElementObservable<Entity: EntityType>(of type: Entity.Type, id: Entity.ID) -> AnyPublisher<Entity?, Never>
    func getAllElements<Entity: EntityType>(of type: Entity.Type) async -> [Entity]
    func getSingleElement<Entity: EntityType>(of type: Entity.Type, id: Entity.ID) async -> Entity?
    func add<Entity: EntityType>(_ element: Entity) async
    func add<Entity: EntityType>(_ elements: [Entity]) async
    func removeSingleElement<Entity: EntityType>(of type: Entity.Type, id: Entity.ID) async throws
    func removeAllElements<Entity: EntityType>(of type: Entity.Type) async
}
