# ReactiveStorage
A slim in-memory storage. Any Identifiable & Equatable entity can be added, without predefining schema. Changes for a particular kind of entity can be observed.

## Usage

### Define your entity:

```swift
struct User: Identifiable, Equatable {
    let id: UUID
    let name: String
}
```

### Create the store:

```swift
let store = ReactiveInMemoryStorage()
```

### Observe type of entity:

```swift
store.getAllElementsObservable(User.self)
    .sink { users in
        // do something
    }
    .store(in: &subscriptions)
```

### Observe a particular entity:

```swift
store.getSingleElementObservable(User.self, id: user.id)
    .sink { user in
        // do something
    }
    .store(in: &subscriptions)
```
If user is not present, a nil value is emited.

### Add element:
```swift
let user = User(id: UUID(), name: "John")
await store.add(user)
```
If element with same id is present, is replaced.

### Get element:
```swift
let user = await store.getSingleElement(User.self, id: user.id)
```

### Get all elements of a type:
```swift
let users = await store.getAlllements(User.self)
```

### Remove element:
```swift
try await store.removeSingleElement(User.self, id: user.id)
```
If element no present, an error is thrown.
