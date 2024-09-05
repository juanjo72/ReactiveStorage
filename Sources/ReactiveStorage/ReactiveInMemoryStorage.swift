//
//  ReactiveInMemoryStorage.swift
//  ReactiveStorage
//
//  Created by Juanjo García Villaescusa on 9/8/24.
//

import Combine
import Foundation

/// A thread-safe, slim in-memory stotage where any Identifiable entity can be added wihout previous configuration.
///
/// - Parameters:
///   - downstreamScheduler: Publishers' downstream scheduler
///
///
public actor ReactiveInMemoryStorage<
    DownstreamScheduler: Scheduler
>: ReactiveStorageProtocol {

    // MARK: Injected

    private let downstreamScheduler: DownstreamScheduler

    // MARK: State

    private var store = [String: any Subject]()

    // MARK: Lifecycle

    public init(
        downstreamScheduler: DownstreamScheduler = DispatchQueue.main
    ) {
        self.downstreamScheduler = downstreamScheduler
    }

    // MARK: LocalDataSource

    nonisolated public func getAllElementsObservable<Entity: EntityType>(of type: Entity.Type) -> AnyPublisher<[Entity], Never> {
        Future() { promise in
            Task {
                let subject = await self.getSubject(of: Entity.self)
                self.downstreamScheduler.schedule {
                    promise(.success(subject))
                }
            }
        }
        .receive(on: self.downstreamScheduler)
        .flatMap { $0 }
        .removeDuplicates()
        .eraseToAnyPublisher()
    }

    nonisolated public func getSingleElementObservable<Entity: EntityType>(of type: Entity.Type, id: Entity.ID) -> AnyPublisher<Entity?, Never> {
        self.getAllElementsObservable(of: Entity.self)
            .map { $0.first { $0.id == id } }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    public func getAllElements<Entity: EntityType>(of type: Entity.Type) async -> [Entity] {
        self.getSubject(of: Entity.self).value
    }

    public func getSingleElement<Entity: EntityType>(of type: Entity.Type, id: Entity.ID) async -> Entity? {
        self.getSubject(of: Entity.self).value
            .first { $0.id == id }
    }

    public func add<Entity: EntityType>(_ element: Entity) async {
        let subject = self.getSubject(of: Entity.self)
        if (subject.value.contains { $0.id == element.id }) {
            subject.value = subject.value.replacingOcurrences(of: element)
        } else {
            subject.value = subject.value.appending(element)
        }
    }

    public func add<Entity: EntityType>(_ elements: [Entity]) async {
        let subject = self.getSubject(of: Entity.self)
        let newValues = elements.reduce(subject.value) { elements, each in
            if (elements.contains { $0.id == each.id }) {
                return elements.replacingOcurrences(of: each)
            } else {
                return elements.appending(each)
            }
        }
        subject.value = newValues
    }

    public func removeSingleElement<Entity: EntityType>(of type: Entity.Type, id: Entity.ID) async {
        let subject = self.getSubject(of: Entity.self)
        subject.value.removeAll { $0.id == id }
    }

    public func removeAllElements<Entity: EntityType>(of type: Entity.Type) async {
        self.getSubject(of: Entity.self).value = []
    }

    // MARK: Private

    private func getSubject<Entity: EntityType>(of type: Entity.Type) -> CurrentValueSubject<[Entity], Never> {
        let key = String(describing: type)
        return store[key] as? CurrentValueSubject<[Entity], Never> ?? {
            let newSubject = CurrentValueSubject<[Entity], Never>([])
            self.store[key] = newSubject
            return newSubject
        }()
    }
}
