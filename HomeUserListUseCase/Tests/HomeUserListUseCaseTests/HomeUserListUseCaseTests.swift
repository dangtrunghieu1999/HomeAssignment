import XCTest
@testable import HomeUserListUseCase

final class MockHomeUserListRepository: HomeUserListRepository {
    var users: [User] = []
    var shouldThrowError = false
    var getUsers: ((Int, Int) -> [User])? = nil
    
    func getUsers(since: Int, perPage: Int) async throws -> [User] {
        if shouldThrowError {
            throw NSError(domain: "TestError", code: -1, userInfo: nil)
        }
        if let customImplementation = getUsers {
            return customImplementation(since, perPage)
        }
        return users
    }
}

final class HomeUserListUseCaseTests: XCTestCase {
    var sut: HomeGetUsersUseCaseImpl!
    var mockRepository: MockHomeUserListRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockHomeUserListRepository()
        sut = HomeGetUsersUseCaseImpl(repository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func test_fetchUserList_success() async throws {
        // Given
        let expectedUsers = [
            User(id: 1, login: "user1", avatarUrl: "url1", htmlUrl: "htmlUrl1"),
            User(id: 2, login: "user2", avatarUrl: "url2", htmlUrl: "htmlUrl2")
        ]
        mockRepository.users = expectedUsers
        
        // When
        let result = try await sut.fetchUserList(since: 0, perPage: 10)
        
        // Then
        XCTAssertEqual(result, expectedUsers)
    }
    
    func test_fetchUserList_failure() async {
        // Given
        mockRepository.shouldThrowError = true
        
        // When/Then
        do {
            _ = try await sut.fetchUserList(since: 0, perPage: 10)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func test_fetchUserList_withEmptyList_success() async throws {
        // Given
        mockRepository.users = []
        
        // When
        let result = try await sut.fetchUserList(since: 0, perPage: 10)
        
        // Then
        XCTAssertTrue(result.isEmpty)
    }
    
    func test_fetchUserList_verifySinceAndPerPageParameters() async throws {
        // Given
        var capturedSince: Int?
        var capturedPerPage: Int?
        
        mockRepository = MockHomeUserListRepository()
        mockRepository.getUsers = { since, perPage in
            capturedSince = since
            capturedPerPage = perPage
            return []
        }
        sut = HomeGetUsersUseCaseImpl(repository: mockRepository)
        
        // When
        let expectedSince = 100
        let expectedPerPage = 20
        _ = try await sut.fetchUserList(since: expectedSince, perPage: expectedPerPage)
        
        // Then
        XCTAssertEqual(capturedSince, expectedSince)
        XCTAssertEqual(capturedPerPage, expectedPerPage)
    }
    
    func test_fetchUserList_withNegativeSince_success() async throws {
        // Given
        let expectedUsers = [
            User(id: 1, login: "user1", avatarUrl: "url1", htmlUrl: "htmlUrl1")
        ]
        mockRepository.users = expectedUsers
        
        // When
        let result = try await sut.fetchUserList(since: -1, perPage: 10)
        
        // Then
        XCTAssertEqual(result, expectedUsers)
    }
}
