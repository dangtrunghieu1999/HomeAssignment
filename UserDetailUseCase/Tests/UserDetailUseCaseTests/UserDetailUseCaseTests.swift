import XCTest
@testable import UserDetailUseCase

// Mock Repository
final class MockUserDetailRepository: UserDetailRepository {
    var getUserDetailCallCount = 0
    var shouldThrowError = false
    var stubbedUserDetail: UserDetail?
    var capturedUsername: String?
    
    enum MockError: Error {
        case someError
    }
    
    func getUserDetail(username: String) async throws -> UserDetail {
        getUserDetailCallCount += 1
        capturedUsername = username
        
        if shouldThrowError {
            throw MockError.someError
        }
        
        return stubbedUserDetail ?? UserDetail(
            id: 1,
            login: username,
            avatarUrl: "https://example.com/avatar.jpg",
            htmlUrl: "https://github.com/\(username)",
            location: "Test Location",
            followers: 100,
            following: 50
        )
    }
}

final class UserDetailUseCaseTests: XCTestCase {
    private var sut: UserDetailUseCaseImpl!
    private var mockRepository: MockUserDetailRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockUserDetailRepository()
        sut = UserDetailUseCaseImpl(repository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testGetUserDetail_WhenSuccessful_ReturnsUserDetail() async throws {
        // Given
        let expectedUsername = "testuser"
        let expectedUserDetail = UserDetail(
            id: 1,
            login: expectedUsername,
            avatarUrl: "https://example.com/avatar.jpg",
            htmlUrl: "https://github.com/testuser",
            location: "Test Location",
            followers: 100,
            following: 50
        )
        mockRepository.stubbedUserDetail = expectedUserDetail
        
        // When
        let result = try await sut.getUserDetail(username: expectedUsername)
        
        // Then
        XCTAssertEqual(mockRepository.getUserDetailCallCount, 1)
        XCTAssertEqual(mockRepository.capturedUsername, expectedUsername)
        XCTAssertEqual(result, expectedUserDetail)
    }
    
    func testGetUserDetail_WhenRepositoryThrowsError_ThrowsError() async {
        // Given
        mockRepository.shouldThrowError = true
        let expectedUsername = "testuser"
        
        // When/Then
        do {
            _ = try await sut.getUserDetail(username: expectedUsername)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(mockRepository.getUserDetailCallCount, 1)
            XCTAssertEqual(mockRepository.capturedUsername, expectedUsername)
        }
    }
    
    func testGetUserDetail_WithEmptyUsername_StillProcessesRequest() async throws {
        // Given
        let emptyUsername = ""
        
        // When
        _ = try await sut.getUserDetail(username: emptyUsername)
        
        // Then
        XCTAssertEqual(mockRepository.getUserDetailCallCount, 1)
        XCTAssertEqual(mockRepository.capturedUsername, emptyUsername)
    }
}
