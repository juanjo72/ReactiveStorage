//
//  ReactiveInMemoryStorageTests.swift
//  ReactiveStorageTests
//
//  Created on 9/8/24.
//

import Combine
import XCTest
@testable import ReactiveStorage

final class ReactiveInMemoryStorageTests: XCTestCase {
    
    // MARK: SUT
    
    private func makeSUT() -> some ReactiveStorage.ReactiveStorageProtocol {
        ReactiveInMemoryStorage(
            downstreamScheduler: Combine.ImmediateScheduler.shared
        )
    }
    
    // MARK: Adding elements
    
    func testThat_GivenEmptyStorage_WhenElementAdded_ThenElemetIsIncluded() async {
        // Given
        let storage = self.makeSUT()
        let fakeUser: User = .makeFake()
        
        // When
        await storage.add(fakeUser)
        let user = await storage.getSingleElement(of: User.self, id: fakeUser.id)
        
        // Then
        XCTAssertNotNil(user)
    }
    
    // MARK: Replacing elements
    
    func testThat_GivenStorageWithEntity_WhenAddedWithSameId_ThenElementIsReplaced() async {
        // Given
        let storage = self.makeSUT()
        let id = UUID()
        let fakeUser: User = .makeFake(id: id, name: "John")
        await storage.add(fakeUser)
        
        // When
        let preUpdateUser = await storage.getSingleElement(of: User.self, id: fakeUser.id)
        await storage.add(User(id: id, name: "Anne"))
        let postUpdateUser = await storage.getSingleElement(of: User.self, id: fakeUser.id)
        
        // Then
        XCTAssertEqual(preUpdateUser?.name, "John")
        XCTAssertEqual(postUpdateUser?.name, "Anne")
    }
    
    // MARK: Observables
    
    func testThat_GivenStorage_WhenSubscribed_ThenStoredValuesAreObserved() async {
        // Given
        let storage = self.makeSUT()
        let fakeUser: User = .makeFake()
        await storage.add(fakeUser)
        
        // When
        var users: [User]?
        _ = storage.getAllElementsObservable(of: User.self)
            .sink {
                users = $0
            }
        
        // Then
        XCTAssertEqual(users, [fakeUser])
    }
    
    func testThat() async {
        let storage = self.makeSUT()
        let maxUsers = 10
        let fakeUsers = await withTaskGroup(
            of: User.self,
            returning: [User].self
        ) { group in
            (0..<maxUsers).forEach { _ in
                group.addTask {
                    return User.makeFake()
                }
            }
            return await group.reduce([]) { $0.appending($1) }
        }
        
        var stored: [User]?
        let x = storage.getAllElementsObservable(of: User.self)
            .sink {
                print($0, separator: "\n")
                stored = $0
            }
        
        await withTaskGroup(of: Void.self) { group in
            fakeUsers.forEach { user in
                group.addTask {
                    await storage.add(user)
                }
            }
        }
        
        XCTAssertEqual(stored?.sorted { $0.id < $1.id }, fakeUsers.sorted { $0.id < $1.id })
        _ = x
    }
}
