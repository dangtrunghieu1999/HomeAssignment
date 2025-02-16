/// # Github Users App Documentation
///
/// ## Architecture Overview
///
/// This app follows the Clean Architecture pattern with MVVM+C (Model-View-ViewModel + Coordinator).
/// The app is structured in layers:
///
/// 1. Presentation Layer (UI)
///    - ViewControllers
///    - ViewModels
///    - Coordinators
///    - Custom Views
///
/// 2. Domain Layer (Business Logic)
///    - Entities
///    - Use Cases
///    - Repository Interfaces
///
/// 3. Data Layer (Data Access)
///    - API Services
///    - Local Storage
///    - Repository Implementations
///
/// ## Key Features
///
/// - Display list of GitHub users
/// - Pagination support (20 items per fetch)
/// - Offline support with local caching
/// - Detailed user information
/// - Pull-to-refresh
/// - Error handling and retry mechanism
///
/// ## Data Flow
///
/// 1. User launches app
/// 2. App checks local storage for cached data
/// 3. If cache is valid (less than 15 minutes old), display cached data
/// 4. If cache is stale or empty, fetch from API
/// 5. New data is cached for future use
///
/// ## Dependencies
///
/// - CoreData for local storage
/// - Combine for reactive programming
/// - URLSession for networking
///
/// ## Error Handling
///
/// The app handles various error cases:
/// - Network errors
/// - API errors
/// - Local storage errors
/// - Data parsing errors
///
/// ## Testing
///
/// The app includes:
/// - Unit tests for ViewModels
/// - Unit tests for Use Cases
/// - Unit tests for Repositories
/// - Mocks for testing
///
/// ## Performance Considerations
///
/// - Image caching for better performance
/// - Pagination to handle large datasets
/// - Background thread for data operations
/// - Efficient CoreData usage
///
/// ## Future Improvements
///
/// - Add search functionality
/// - Implement repository filtering
/// - Add user authentication
/// - Support for dark mode
/// - Localization support
