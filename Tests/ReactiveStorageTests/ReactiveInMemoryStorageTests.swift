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
        ReactiveInMemoryStorage()
    }
    
    // MARK: Adding elements
    
    func testThat_GivenEmptyStorage_WhenElementAdded_ThenElemetIsIncluded() async {
        // Given
        let storage = self.makeSUT()
        let fakeUser: User = .make()
        
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
        let fakeUser: User = .make(id: id, name: "John")
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
        let user_1: User = .make()
        await storage.add(user_1)
        
        // When
        var users: [User]?
        let subscription = storage.getAllElementsObservable(of: User.self)
            .print("[subscription]")
            .sink {
                users = $0
            }
        
        let user_2: User = .make()
        await storage.add(user_2)
        
        // Then
        print(String(describing: users))
        XCTAssertEqual(users?.sorted(), [user_1, user_2].sorted())
        _ = subscription
    }
}
