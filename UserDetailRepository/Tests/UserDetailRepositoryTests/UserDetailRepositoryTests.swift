import XCTest
import UserDetailUseCase
import NetworkService
@testable import UserDetailRepository

final class UserDetailRepositoryTests: XCTestCase {
    var sut: UserDetailRepositoryImpl!
    var mockNetworkService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        sut = UserDetailRepositoryImpl(networkService: mockNetworkService)
    }
    
    override func tearDown() {
        sut = nil
        mockNetworkService = nil
        super.tearDown()
    }
    
    func test_getUserDetail_success() async throws {
        // Given
        let expectedUsername = "testuser"
        let mockUserDetail = UserDetailData(
            id: 1,
            login: expectedUsername,
            avatarUrl: "https://example.com/avatar.jpg",
            htmlUrl: "https://github.com/testuser",
            location: "Test Location",
            followers: 100,
            following: 50
        )
        mockNetworkService.mockResponse = mockUserDetail
        
        // When
        let result = try await sut.getUserDetail(username: expectedUsername)
        
        // Then
        XCTAssertEqual(result.id, 1)
        XCTAssertEqual(result.login, expectedUsername)
        XCTAssertEqual(result.avatarUrl, "https://example.com/avatar.jpg")
        XCTAssertEqual(result.htmlUrl, "https://github.com/testuser")
        XCTAssertEqual(result.location, "Test Location")
        XCTAssertEqual(result.followers, 100)
        XCTAssertEqual(result.following, 50)
    }
    
    func test_getUserDetail_withNullableFields() async throws {
        // Given
        let expectedUsername = "testuser"
        let mockUserDetail = UserDetailData(
            id: 1,
            login: expectedUsername,
            avatarUrl: "https://example.com/avatar.jpg",
            htmlUrl: "https://github.com/testuser",
            location: nil,
            followers: 100,
            following: 50
        )
        mockNetworkService.mockResponse = mockUserDetail
        
        // When
        let result = try await sut.getUserDetail(username: expectedUsername)
        
        // Then
        XCTAssertEqual(result.id, 1)
        XCTAssertEqual(result.login, expectedUsername)
        XCTAssertNil(result.location)
    }
    
    func test_getUserDetail_networkError() async {
        // Given
        let expectedError = NSError(domain: "NetworkError", code: -1)
        mockNetworkService.mockError = expectedError
        
        // When/Then
        do {
            _ = try await sut.getUserDetail(username: "testuser")
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertEqual((error as NSError).domain, expectedError.domain)
            XCTAssertEqual((error as NSError).code, expectedError.code)
        }
    }
    
    func test_getUserDetail_invalidResponse() async {
        // Given
        mockNetworkService.mockResponse = "Invalid Response"
        
        // When/Then
        do {
            _ = try await sut.getUserDetail(username: "testuser")
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is MockNetworkService.MockError)
        }
    }
}

// MARK: - Mock NetworkService
class MockNetworkService: NetworkService {
    enum MockError: Error {
        case invalidResponse
    }
    
    var mockResponse: Any?
    var mockError: Error?
    
    func request<T>(_ url: URL, method: HTTPMethod, headers: [String : String]?) async throws -> T where T : Decodable {
        if let error = mockError {
            throw error
        }
        
        if let response = mockResponse as? T {
            return response
        }
        
        throw MockError.invalidResponse
    }
}
