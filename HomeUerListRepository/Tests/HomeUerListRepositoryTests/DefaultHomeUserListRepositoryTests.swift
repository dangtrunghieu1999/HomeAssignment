import XCTest
import HomeUerListRepository

@testable import HomeUerListRepository
@testable import NetworkService

final class MockNetworkService: NetworkService {
    var mockResponse: Any?
    var mockError: Error?
    var capturedURL: URL?
    var capturedMethod: HTTPMethod?
    var capturedHeaders: [String: String]?
    
    func request<T>(_ url: URL, method: HTTPMethod, headers: [String : String]?) async throws -> T where T : Decodable {
        capturedURL = url
        capturedMethod = method
        capturedHeaders = headers
        
        if let error = mockError {
            throw error
        }
        
        if let response = mockResponse as? T {
            return response
        }
        
        throw NSError(domain: "MockError", code: -1)
    }
}

final class DefaultHomeUserListRepositoryTests: XCTestCase {
    var sut: HomeUserListRepositoryImpl!
    var mockNetworkService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        sut = HomeUserListRepositoryImpl(networkService: mockNetworkService)
    }
    
    override func tearDown() {
        sut = nil
        mockNetworkService = nil
        super.tearDown()
    }
    
    func test_getUsers_success() async throws {
        // Given
        let mockUsers: [UserData] = [
            .init(id: 1, login: "user1", avatarUrl: "https://example.com/avatar1", htmlUrl: "URL1"),
            .init(id: 2, login: "user2", avatarUrl: "https://example.com/avatar2", htmlUrl: "URL2")
        ]
        mockNetworkService.mockResponse = mockUsers
        
        // When
        let result = try await sut.getUsers(since: 0, perPage: 10)
        
        // Then
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].id, 1)
        XCTAssertEqual(result[0].login, "user1")
        XCTAssertEqual(result[0].avatarUrl, "https://example.com/avatar1")
        XCTAssertEqual(result[0].htmlUrl, "URL1")
        XCTAssertEqual(result[1].id, 2)
        XCTAssertEqual(result[1].login, "user2")
        XCTAssertEqual(result[1].avatarUrl, "https://example.com/avatar2")
        XCTAssertEqual(result[1].htmlUrl, "URL2")
    }
    
    func test_getUsers_verifyRequestParameters() async throws {
        // Given
        let since = 10
        let perPage = 20
        mockNetworkService.mockResponse = [UserData]()
        
        // When
        _ = try await sut.getUsers(since: since, perPage: perPage)
        
        // Then
        XCTAssertEqual(mockNetworkService.capturedMethod, .get)
        XCTAssertNotNil(mockNetworkService.capturedURL)
        XCTAssertTrue(mockNetworkService.capturedURL?.absoluteString.contains("since=\(since)") ?? false)
        XCTAssertTrue(mockNetworkService.capturedURL?.absoluteString.contains("per_page=\(perPage)") ?? false)
    }
    
    func test_getUsers_failure() async {
        // Given
        let expectedError = NSError(domain: "TestError", code: -1)
        mockNetworkService.mockError = expectedError
        
        // When/Then
        do {
            _ = try await sut.getUsers(since: 0, perPage: 10)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertEqual((error as NSError).domain, expectedError.domain)
            XCTAssertEqual((error as NSError).code, expectedError.code)
        }
    }
    
    func test_getUsers_emptyResponse() async throws {
        // Given
        mockNetworkService.mockResponse = [UserData]()
        
        // When
        let result = try await sut.getUsers(since: 0, perPage: 10)
        
        // Then
        XCTAssertTrue(result.isEmpty)
    }
} 
