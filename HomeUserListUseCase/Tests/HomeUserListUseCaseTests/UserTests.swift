import XCTest
@testable import HomeUserListUseCase

final class UserTests: XCTestCase {
    func test_userInitialization_success() {
        // Given
        let id = 1
        let login = "testUser"
        let avatarUrl = "https://example.com/avatar.jpg"
        let htmlUrl = "https://example.com/user"
        
        // When
        let user = User(id: id, login: login, avatarUrl: avatarUrl, htmlUrl: htmlUrl)
        
        // Then
        XCTAssertEqual(user.id, id)
        XCTAssertEqual(user.login, login)
        XCTAssertEqual(user.avatarUrl, avatarUrl)
        XCTAssertEqual(user.htmlUrl, htmlUrl)
    }
    
    func test_userEquatable_shouldBeEqual() {
        // Given
        let user1 = User(id: 1, login: "user1", avatarUrl: "url1", htmlUrl: "htmlUrl1")
        let user2 = User(id: 1, login: "user1", avatarUrl: "url1", htmlUrl: "htmlUrl1")
        
        // Then
        XCTAssertEqual(user1, user2)
    }
    
    func test_userEquatable_shouldNotBeEqual() {
        // Given
        let user1 = User(id: 1, login: "user1", avatarUrl: "url1", htmlUrl: "htmlUrl1")
        let user2 = User(id: 2, login: "user1", avatarUrl: "url1", htmlUrl: "htmlUrl1")
        let user3 = User(id: 1, login: "user2", avatarUrl: "url1", htmlUrl: "htmlUrl1")
        let user4 = User(id: 1, login: "user1", avatarUrl: "url2", htmlUrl: "htmlUrl1")
        let user5 = User(id: 1, login: "user1", avatarUrl: "url1", htmlUrl: "htmlUrl2")
        
        // Then
        XCTAssertNotEqual(user1, user2) // Different id
        XCTAssertNotEqual(user1, user3) // Different login
        XCTAssertNotEqual(user1, user4) // Different avatarUrl
        XCTAssertNotEqual(user1, user5) // Different htmlUrl
    }
} 