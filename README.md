# Swift app

## Project Structure

```
Swift app/
├── Views/
│   ├── ContentView.swift
│   ├── HomeView.swift
│   ├── ProfileView.swift
│   └── HomeCard.swift
├── ViewModels/
│   └── HomeViewModel.swift
├── Models/
│   └── HomeItem.swift
├── Resources/
│   └── ... (assets, colors, etc.)
├── Swift_appApp.swift
└── ...
```

- **Views/**: All SwiftUI view components (screens, cards, etc.)
- **ViewModels/**: ObservableObject classes for business logic and state
- **Models/**: Data structures (Codable, Identifiable, etc.)
- **Resources/**: Images, colors, and other assets

## SwiftUI State Management Concepts

### `@State`

- Used for simple, local view state (e.g., toggles, counters)
- Triggers a view update when changed
- Example:
  ```swift
  @State private var isOn = false
  ```

### `@StateObject`

- Used to own a reference type (ObservableObject) for the lifetime of a view
- Ensures the view model is created once and survives view updates
- Example:
  ```swift
  @StateObject private var viewModel = HomeViewModel()
  ```

### `@Published`

- Used inside ObservableObject classes to mark properties that should trigger view updates
- Example:
  ```swift
  class HomeViewModel: ObservableObject {
      @Published var items: [HomeItem] = []
  }
  ```

### `ObservableObject` and `@ObservedObject`

- `ObservableObject` is a protocol for classes that can be observed by SwiftUI views
- `@ObservedObject` is used in child views to observe a view model owned elsewhere

## App Architecture

- **MVVM**: Models, Views, and ViewModels are separated for clarity and testability
- **Async/Await**: Networking uses Swift Concurrency for clean, modern async code
- **Componentization**: UI is split into reusable, focused components

## How it works

- The app fetches video data from an API and displays it in a horizontally scrolling card UI on the Home tab
- State and data flow is managed using SwiftUI's property wrappers and MVVM best practices
