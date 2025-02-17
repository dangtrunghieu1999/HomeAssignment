import XCTest
@testable import UserDetailUseCase

final class UserDetailTests: XCTestCase {
    func testUserDetailInitialization() {
        // Given
        let id = 1
        let login = "johndoe"
        let avatarUrl = "https://example.com/avatar.jpg"
        let htmlUrl = "https://github.com/johndoe"
        let location = "New York"
        let followers = 100
        let following = 50
        
        // When
        let userDetail = UserDetail(
            id: id,
            login: login,
            avatarUrl: avatarUrl,
            htmlUrl: htmlUrl,
            location: location,
            followers: followers,
            following: following
        )
        
        // Then
        XCTAssertEqual(userDetail.id, id)
        XCTAssertEqual(userDetail.login, login)
        XCTAssertEqual(userDetail.avatarUrl, avatarUrl)
        XCTAssertEqual(userDetail.htmlUrl, htmlUrl)
        XCTAssertEqual(userDetail.location, location)
        XCTAssertEqual(userDetail.followers, followers)
        XCTAssertEqual(userDetail.following, following)
    }
    
    func testUserDetailEquatable() {
        // Given
        let userDetail1 = UserDetail(
            id: 1,
            login: "johndoe",
            avatarUrl: "https://example.com/avatar.jpg",
            htmlUrl: "https://github.com/johndoe",
            location: "New York",
            followers: 100,
            following: 50
        )
        
        let userDetail2 = UserDetail(
            id: 1,
            login: "johndoe",
            avatarUrl: "https://example.com/avatar.jpg",
            htmlUrl: "https://github.com/johndoe",
            location: "New York",
            followers: 100,
            following: 50
        )
        
        let userDetail3 = UserDetail(
            id: 2, // Different ID
            login: "johndoe",
            avatarUrl: "https://example.com/avatar.jpg",
            htmlUrl: "https://github.com/johndoe",
            location: "New York",
            followers: 100,
            following: 50
        )
        
        // Then
        XCTAssertEqual(userDetail1, userDetail2)
        XCTAssertNotEqual(userDetail1, userDetail3)
    }
    
    func testUserDetailWithNilLocation() {
        // Given
        let userDetail = UserDetail(
            id: 1,
            login: "johndoe",
            avatarUrl: "https://example.com/avatar.jpg",
            htmlUrl: "https://github.com/johndoe",
            location: nil,
            followers: 100,
            following: 50
        )
        
        // Then
        XCTAssertNil(userDetail.location)
    }
} 