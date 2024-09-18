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

Create the RemoteResource:

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

Get element:

```swift
try await storage.getSingleElement(User.self, id: user.id)
```

Remove element:

```swift
try await storage.removeSingleElement(User.self, id: user.id)
```
