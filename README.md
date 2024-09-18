# ReactiveStorage
A slim implementation of in-memory storage

## Usage

Define your entity, both identifiable and equatable:

```swift
struct User: Identifiable, Equatable {
    let id: UUID
    let name: String
}
```

Create the store:

```swift
let storage = ReactiveInMemoryStorage()
```

Observe elements:

```swift
storage.getAllElementsObservable(User.self)
    .sink { users in
        // do something with the users
    }
    .store(in: &subscriptions)
```

Add element:
```swift
let user = User(id: UUID(), name: "John")
await storage.add(user)
```
If element with same id is present, is replaced.

Get element:
```swift
let user = await storage.getSingleElement(User.self, id: user.id)
```

Get all elements of a type:
```swift
let users = await storage.getAlllements(User.self)
```

Remove element:
```swift
try await storage.removeSingleElement(User.self, id: user.id)
```
If element no present, an error is thrown.