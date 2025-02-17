import XCTest
import UserDetailUseCase
@testable import UserDetailRepository

final class UserDetailDataTests: XCTestCase {
    func test_decode_userDetailData_successfully() throws {
        // Given
        let json = """
        {
            "id": 1,
            "login": "testUser",
            "avatar_url": "https://example.com/avatar.jpg",
            "html_url": "https://github.com/testUser",
            "location": "Test City",
            "followers": 100,
            "following": 50
        }
        """.data(using: .utf8)!
        
        // When
        let sut = try JSONDecoder().decode(UserDetailData.self, from: json)
        
        // Then
        XCTAssertEqual(sut.id, 1)
        XCTAssertEqual(sut.login, "testUser")
        XCTAssertEqual(sut.avatarUrl, "https://example.com/avatar.jpg")
        XCTAssertEqual(sut.htmlUrl, "https://github.com/testUser")
        XCTAssertEqual(sut.location, "Test City")
        XCTAssertEqual(sut.followers, 100)
        XCTAssertEqual(sut.following, 50)
    }
    
    func test_decode_userDetailData_withNullLocation_successfully() throws {
        // Given
        let json = """
        {
            "id": 1,
            "login": "testUser",
            "avatar_url": "https://example.com/avatar.jpg",
            "html_url": "https://github.com/testUser",
            "location": null,
            "followers": 100,
            "following": 50
        }
        """.data(using: .utf8)!
        
        // When
        let sut = try JSONDecoder().decode(UserDetailData.self, from: json)
        
        // Then
        XCTAssertNil(sut.location)
    }
    
    func test_mapData_returnsCorrectUserDetail() {
        // Given
        let sut = UserDetailData(
            id: 1,
            login: "testUser",
            avatarUrl: "https://example.com/avatar.jpg",
            htmlUrl: "https://github.com/testUser",
            location: "Test City",
            followers: 100,
            following: 50
        )
        
        // When
        let userDetail = sut.mapData()
        
        // Then
        XCTAssertEqual(userDetail.id, sut.id)
        XCTAssertEqual(userDetail.login, sut.login)
        XCTAssertEqual(userDetail.avatarUrl, sut.avatarUrl)
        XCTAssertEqual(userDetail.htmlUrl, sut.htmlUrl)
        XCTAssertEqual(userDetail.location, sut.location)
        XCTAssertEqual(userDetail.followers, sut.followers)
        XCTAssertEqual(userDetail.following, sut.following)
    }
} 