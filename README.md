
---

# Rogram: The Home Feed Experience

**Rogram** is an iOS application designed as an interview challenge for Ro, aimed at implementing a basic version of their home screen feed. However, this challenge has been extended to showcase advanced iOS development techniques, including custom transitions, networking, and UI layouts.

![Rogram Video Demo](https://github.com/user-attachments/assets/60d370bd-4cfb-4be2-8d04-2dc6f094d3a0)
*Click the image above to watch the video demo* *Please compile natively for full resolution, compression degrades quality!*


## 🌟 Features

- **Dynamic Album Management**: Browse through albums, view their photos, and enjoy a seamless experience powered by custom transitions.
- **Custom Presentations**: Transitions between views are smooth and captivating, offering a visually pleasing experience.
- **Scalable Architecture**: The project is designed with scalability in mind, with room for future enhancements like pagination and thumbnail previews.

## 📂 Project Structure

```
Rogram/
│
├── Rogram/
│   ├── Services/
│   ├── Layouts/
│   ├── Transitions/
│   ├── Views/
│   ├── Models/
│   └── Controllers/
```

### Services: Powering Networking

Rogram’s networking layer is both robust and flexible, making use of dependency injection for ease of testing and extension.

- **NetworkService.swift**: Implements the `NetworkProtocol`, providing the foundation for executing network requests.
- **PostService.swift**: Injects `NetworkService` to fetch posts for specific album routes (`/album/1/photos`, `/album/2/photos`, etc.).
- **AlbumCollectionService.swift**: Injects `NetworkService` to fetch albums. Currently, the app is limited to the first 10 albums, but a future enhancement could include pagination via a "Show More" button.

**Testing**: Thanks to the injectable nature of our networking layer, testing components like `MockNetworkService` are straightforward to implement. This allows for mocking services at a granular level, ensuring comprehensive and isolated unit tests.

```swift
class MockNetworkService: NetworkProtocol {
    var executeRequestResult: Any?
    var executeRequestError: Error?
    
    func executeRequest<T>(urlString: String) async throws -> T? where T: Decodable {
        if let error = executeRequestError {
            throw error
        }
        return executeRequestResult as? T
    }
    
    var fetchImageResult: UIImage?
    var fetchImageError: Error?
    
    func fetchImageForURL(_ urlString: String) async throws -> UIImage? {
        if let error = fetchImageError {
            throw error
        }
        return fetchImageResult
    }
}
```

### Layouts: Designing the UI

Rogram’s layouts are thoughtfully designed to provide an engaging and user-friendly interface.

- **FeaturedPostsLayout.swift**: A standard vertical layout to showcase images and their corresponding titles.
- **AlbumCollectionsLayout.swift**: A Pinterest-inspired layout featuring vertical, side-by-side columns.

**Future Enhancement**: Implement thumbnail previews for albums instead of random color assortments, enhancing the visual coherence and user experience.

### Custom Presentations: Elevating Transitions

Rogram’s custom presentations add a layer of sophistication to the app, making transitions between views not just functional but also visually appealing.

- **PhotoTransitionDelegate.swift**: Facilitates the transition between view controllers, utilizing a configurable `startingFrame` property to initiate the animation from the tapped cell’s position.
- **PhotoDetailAnimator.swift**: Implements the scaling and fading animations that bring a unique touch to view transitions.
- **PhotoDetailPresentationController.swift**: Provides the `endFrame` for the destination view controller, ensuring smooth and consistent transitions.

### Views: Custom UI Components

The custom views in Rogram are designed to enhance interactivity and visual appeal.

- **ScalableContainerView.swift**: A custom `UIView` subclass that handles tap events and provides a scaling animation during touch interactions.
- **ConfigurableHeaderView.swift**: A versatile header view used across view controllers, with an optional dismissal button that integrates seamlessly with the custom presentation logic.

## 🚀 Getting Started

### Prerequisites

Ensure you have the following:

- **Xcode 13.0 or higher**
- **iOS 14.0 or higher**

### Installation

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/matthewharrilal/Rogram.git
   cd Rogram
   ```

2. **Open the Project**:
   Open `Rogram.xcworkspace` in Xcode.

3. **Build and Run**:
   Select your target device or simulator and press `Cmd + R` to build and run the app.

## 🧪 Testing

Rogram includes a suite of unit and integration tests to ensure the stability and reliability of the app.

### Unit Tests

- **NetworkServiceTests**: Validates the network layer, ensuring data retrieval and error handling are correct.
- **PostFetcherImplementationTests**: Verifies the logic for streaming aggregated posts.
- **AlbumFetcherServiceTests**: Ensures the album fetching service operates correctly.

### Running Tests

1. **Open Rogram in Xcode**.
2. **Run Tests**: Press `Cmd + U` or go to `Product > Test` to run all tests.

## 🛠️ Future Enhancements

- **Thumbnail Previews**: Implement thumbnail images for albums.
- **Pagination**: Add pagination for album collections, allowing users to load more albums with a "Show More" button.
- **Refined Animations**: Continue to refine and enhance the custom animations for an even smoother user experience.

---
