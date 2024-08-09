//
//  ReactiveInMemoryStorageTests.swift
//  ReactiveStorageTests
//
//  Created by Juanjo García Villaescusa on 9/8/24.
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
}
