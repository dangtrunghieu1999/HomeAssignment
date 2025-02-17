import XCTest
import HomeUserListUseCase
@testable import HomeAssignment

final class UserListViewModelTests: XCTestCase {
    
    private var sut: UserListViewModel!
    private var mockUseCase: MockHomeGetUsersUseCase!
    
    override func setUp() {
        super.setUp()
        mockUseCase = MockHomeGetUsersUseCase()
        sut = UserListViewModel(getUsersUseCase: mockUseCase)
    }
    
    override func tearDown() {
        sut = nil
        mockUseCase = nil
        super.tearDown()
    }
    
    // MARK: - viewDidLoad Tests
    
    func test_viewDidLoad_shouldLoadFirstPage() async {
        // Given
        let expectedUsers = createMockUsers(count: 20)
        mockUseCase.mockUsers = expectedUsers
        
        // When
        await sut.viewDidLoad()
        
        // Then
        XCTAssertEqual(sut.users, expectedUsers)
        XCTAssertEqual(sut.state, .loaded(expectedUsers))
        XCTAssertEqual(mockUseCase.fetchUserListCallCount, 1)
        XCTAssertEqual(mockUseCase.lastSince, 0)
        XCTAssertEqual(mockUseCase.lastPerPage, 20)
    }
    
    func test_viewDidLoad_whenErrorOccurs_shouldUpdateStateWithError() async {
        // Given
        let expectedError = NSError(domain: "test", code: -1)
        mockUseCase.mockError = expectedError
        
        // When
        await sut.viewDidLoad()
        
        // Then
        if case .error(let error as NSError) = sut.state {
            XCTAssertEqual(error, expectedError)
        } else {
            XCTFail("Expected error state")
        }
        XCTAssertTrue(sut.users.isEmpty)
    }
    
    // MARK: - loadMore Tests
    
    func test_loadMore_whenHasMorePages_shouldLoadNextPage() async {
        // Given
        let firstPageUsers = createMockUsers(count: 20)
        let secondPageUsers = createMockUsers(count: 20, startId: 20)
        mockUseCase.mockUsers = firstPageUsers
        
        // When
        await sut.viewDidLoad() // Load first page
        mockUseCase.mockUsers = secondPageUsers
        await sut.loadMore()
        
        // Then
        XCTAssertEqual(sut.users, firstPageUsers + secondPageUsers)
        XCTAssertEqual(mockUseCase.fetchUserListCallCount, 2)
        XCTAssertEqual(mockUseCase.lastSince, 20)
    }
    
    func test_loadMore_whenNoMorePages_shouldNotLoadMore() async {
        // Given
        let users = createMockUsers(count: 10) // Less than perPage
        mockUseCase.mockUsers = users
        
        // When
        await sut.viewDidLoad()
        await sut.loadMore()
        
        // Then
        XCTAssertEqual(mockUseCase.fetchUserListCallCount, 1)
        XCTAssertEqual(sut.users.count, 10)
    }
    
    // MARK: - refresh Tests
    
    func test_refresh_shouldResetAndReloadData() async {
        // Given
        let firstLoad = createMockUsers(count: 20)
        let refreshedUsers = createMockUsers(count: 20, startId: 100)
        mockUseCase.mockUsers = firstLoad
        
        // When
        await sut.viewDidLoad()
        mockUseCase.mockUsers = refreshedUsers
        await sut.refresh()
        
        // Then
        XCTAssertEqual(sut.users, refreshedUsers)
        XCTAssertEqual(mockUseCase.lastSince, 0)
    }
    
    // MARK: - Helper Methods
    
    private func createMockUsers(count: Int, startId: Int = 0) -> [User] {
        return (0..<count).map { index in
            User(id: startId + index,
                 login: "user\(startId + index)",
                 avatarUrl: "https://example.com/avatar\(startId + index)",
                 htmlUrl: "User")
        }
    }
}

// MARK: - Mock UseCase

private final class MockHomeGetUsersUseCase: HomeGetUsersUseCase {
    var mockUsers: [User] = []
    var mockError: Error?
    var fetchUserListCallCount = 0
    var lastSince: Int = 0
    var lastPerPage: Int = 0
    
    func fetchUserList(since: Int, perPage: Int) async throws -> [User] {
        fetchUserListCallCount += 1
        lastSince = since
        lastPerPage = perPage
        
        if let error = mockError {
            throw error
        }
        return mockUsers
    }
} 
