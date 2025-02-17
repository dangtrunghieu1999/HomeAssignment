import XCTest
@testable import HomeUerListRepository
@testable import HomeUserListUseCase

final class UserRepositoryTests: XCTestCase {
    
    func test_decode_shouldDecodeCorrectly() throws {
        // Given
        let json = """
        {
            "id": 1,
            "login": "testUser",
            "avatar_url": "https://example.com/avatar.jpg",
            "html_url": "https://example.com/user"
        }
        """.data(using: .utf8)!
        
        // When
        let sut = try JSONDecoder().decode(UserRepository.self, from: json)
        
        // Then
        XCTAssertEqual(sut.id, 1)
        XCTAssertEqual(sut.login, "testUser")
        XCTAssertEqual(sut.avatarUrl, "https://example.com/avatar.jpg")
        XCTAssertEqual(sut.htmlUrl, "https://example.com/user")
    }
    
    func test_mapData_shouldMapToUserCorrectly() {
        // Given
        let sut = UserRepository(
            id: 1,
            login: "testUser",
            avatarUrl: "https://example.com/avatar.jpg",
            htmlUrl: "https://example.com/user"
        )
        
        // When
        let user = sut.mapData()
        
        // Then
        XCTAssertEqual(user.id, sut.id)
        XCTAssertEqual(user.login, sut.login)
        XCTAssertEqual(user.avatarUrl, sut.avatarUrl)
        XCTAssertEqual(user.htmlUrl, sut.htmlUrl)
    }
    
    func test_request_withNetworkError_shouldThrowError() async throws {
        // Given
        let mockURLSession = MockURLSession()
        let sut = DefaultHomeUserListRepository(
            session: mockURLSession,
            baseURL: URL(string: "https://api.github.com")!
        )
        struct MockError: Error {}
        mockURLSession.mockError = MockError()
        
        // When/Then
        do {
            _ = try await sut.fetchUsers()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is MockError)
        }
    }
}

// Add MockURLSession for testing
private class MockURLSession: URLSessionProtocol {
    var mockError: Error?
    var mockData: Data?
    var mockResponse: URLResponse?
    
    func data(
        for request: URLRequest,
        delegate: URLSessionTaskDelegate?
    ) async throws -> (Data, URLResponse) {
        if let error = mockError {
            throw error
        }
        return (
            mockData ?? Data(),
            mockResponse ?? HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
        )
    }
}

// Add protocol for URLSession to make it testable
protocol URLSessionProtocol {
    func data(
        for request: URLRequest,
        delegate: URLSessionTaskDelegate?
    ) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {} 