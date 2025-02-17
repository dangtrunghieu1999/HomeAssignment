import XCTest
@testable import NetworkService

final class NetworkServiceTests: XCTestCase {
    var sut: URLSessionNetworkService!
    var mockSession: MockURLSession!
    var mockLogger: MockNetworkLogger!
    
    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        mockLogger = MockNetworkLogger()
        sut = URLSessionNetworkService(session: mockSession, logger: mockLogger)
    }
    
    override func tearDown() {
        sut = nil
        mockSession = nil
        mockLogger = nil
        super.tearDown()
    }
}

// MARK: - Successful Cases
extension NetworkServiceTests {
    func test_request_withSuccessfulResponse_shouldDecodeData() async throws {
        // Given
        let expectedUser = TestUser(id: 1, name: "Test User")
        let jsonData = try JSONEncoder().encode(expectedUser)
        mockSession.data = jsonData
        mockSession.response = HTTPURLResponse(
            url: URL(string: "https://api.github.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        // When
        let result: TestUser = try await sut.request(
            URL(string: "https://api.github.com")!,
            method: .get,
            headers: nil
        )
        
        // Then
        XCTAssertEqual(result.id, expectedUser.id)
        XCTAssertEqual(result.name, expectedUser.name)
        XCTAssertEqual(mockLogger.loggedRequests.count, 1)
        XCTAssertEqual(mockLogger.loggedResponses.count, 1)
    }
}

// MARK: - Error Cases
extension NetworkServiceTests {
    func test_request_withUnauthorizedResponse_shouldThrowUnauthorizedError() async {
        // Given
        mockSession.response = HTTPURLResponse(
            url: URL(string: "https://api.github.com")!,
            statusCode: 401,
            httpVersion: nil,
            headerFields: nil
        )
        
        // When/Then
        await assertThrows(
            try await sut.request(URL(string: "https://api.github.com")!, method: .get) as TestUser,
            GithubError.unauthorized
        )
    }
    
    func test_request_withNotFoundResponse_shouldThrowUserNotFoundError() async {
        // Given
        mockSession.response = HTTPURLResponse(
            url: URL(string: "https://api.github.com")!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )
        
        // When/Then
        await assertThrows(
            try await sut.request(URL(string: "https://api.github.com")!, method: .get) as TestUser,
            GithubError.userNotFound
        )
    }
    
    func test_request_withRateLimitResponse_shouldThrowRateLimitError() async {
        // Given
        mockSession.response = HTTPURLResponse(
            url: URL(string: "https://api.github.com")!,
            statusCode: 429,
            httpVersion: nil,
            headerFields: nil
        )
        
        // When/Then
        await assertThrows(
            try await sut.request(URL(string: "https://api.github.com")!, method: .get) as TestUser,
            GithubError.rateLimitExceeded
        )
    }
    
    func test_request_withServerError_shouldThrowServerError() async {
        // Given
        mockSession.response = HTTPURLResponse(
            url: URL(string: "https://api.github.com")!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )
        
        // When/Then
        await assertThrows(
            try await sut.request(URL(string: "https://api.github.com")!, method: .get) as TestUser,
            GithubError.serverError
        )
    }
    
    func test_request_withNetworkError_shouldThrowAndLogError() async {
        // Given
        struct TestNetworkError: Error {}
        mockSession.error = TestNetworkError()
        
        // When/Then
        do {
            let _: TestUser = try await sut.request(
                URL(string: "https://api.github.com")!,
                method: .get
            )
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(mockLogger.loggedErrors.count, 1)
            XCTAssertTrue(error is TestNetworkError)
        }
    }
}

// MARK: - Logging Tests
extension NetworkServiceTests {
    func test_request_shouldLogRequestAndResponse() async throws {
        // Given
        let expectedUser = TestUser(id: 1, name: "Test User")
        mockSession.data = try JSONEncoder().encode(expectedUser)
        mockSession.response = HTTPURLResponse(
            url: URL(string: "https://api.github.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        // When
        _ = try await sut.request(
            URL(string: "https://api.github.com")!,
            method: .get,
            headers: ["Authorization": "Bearer token"]
        ) as TestUser
        
        // Then
        XCTAssertEqual(mockLogger.loggedRequests.count, 1)
        XCTAssertEqual(mockLogger.loggedResponses.count, 1)
        XCTAssertEqual(mockLogger.loggedRequests.first?.allHTTPHeaderFields?["Authorization"], "Bearer token")
    }
}

// MARK: - Helper Methods
extension NetworkServiceTests {
    private func assertThrows<T: Decodable>(
        _ expression: @autoclosure () async throws -> T,
        _ expectedError: GithubError,
        file: StaticString = #filePath,
        line: UInt = #line
    ) async {
        do {
            _ = try await expression()
            XCTFail("Expected error \(expectedError)", file: file, line: line)
        } catch {
            XCTAssertEqual(error as? GithubError, expectedError, file: file, line: line)
            XCTAssertEqual(mockLogger.loggedErrors.count, 1)
            XCTAssertEqual(mockLogger.loggedErrors[0].error as? GithubError, expectedError)
        }
    }
}

// MARK: - Test Models
private struct TestUser: Codable, Equatable {
    let id: Int
    let name: String
}

final class MockNetworkLogger: NetworkLogging {
    var loggedRequests: [URLRequest] = []
    var loggedResponses: [(data: Data, response: URLResponse)] = []
    var loggedErrors: [(error: Error, statusCode: Int?)] = []
    
    func logRequest(_ request: URLRequest) {
        loggedRequests.append(request)
    }
    
    func logResponse(data: Data, response: URLResponse) {
        loggedResponses.append((data, response))
    }
    
    func logError(_ error: Error, statusCode: Int?) {
        loggedErrors.append((error: error, statusCode: statusCode))
    }
}
