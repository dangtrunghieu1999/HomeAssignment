import XCTest
import UserDetailUseCase
@testable import HomeAssignment

final class UserDetailViewModelTests: XCTestCase {
    
    private var sut: UserDetailViewModel!
    private var mockUseCase: MockUserGetDetailUseCase!
    private let username = "testUser"
    
    override func setUp() {
        super.setUp()
        mockUseCase = MockUserGetDetailUseCase()
        sut = UserDetailViewModel(username: username, getUserDetailUseCase: mockUseCase)
    }
    
    override func tearDown() {
        sut = nil
        mockUseCase = nil
        super.tearDown()
    }
    
    func test_loadUserDetail_Success() async {
        // Given
        let expectedDetail = UserDetail.mock()
        mockUseCase.result = .success(expectedDetail)
        
        // When
        await sut.loadUserDetail()
        
        // Then
        XCTAssertEqual(sut.detailState.data, expectedDetail)
        XCTAssertFalse(sut.detailState.isLoading)
        XCTAssertNil(sut.detailState.error)
    }
    
    func test_loadUserDetail_Failure() async {
        // Given
        let expectedError = NSError(domain: "test", code: -1)
        mockUseCase.result = .failure(expectedError)
        
        // When
        await sut.loadUserDetail()
        
        // Then
        XCTAssertNil(sut.detailState.data)
        XCTAssertFalse(sut.detailState.isLoading)
        XCTAssertNotNil(sut.detailState.error)
    }
    
    func test_refresh_ClearsDataAndReloads() async {
        // Given
        let initialDetail = UserDetail.mock()
        let newDetail = UserDetail.mock(id: 2)
        mockUseCase.result = .success(initialDetail)
        
        // When
        await sut.loadUserDetail()
        XCTAssertEqual(sut.detailState.data, initialDetail)
        
        mockUseCase.result = .success(newDetail)
        await sut.refresh()
        
        // Then
        XCTAssertEqual(sut.detailState.data, newDetail)
        XCTAssertFalse(sut.detailState.isLoading)
        XCTAssertNil(sut.detailState.error)
    }
}

// MARK: - Mocks
private final class MockUserGetDetailUseCase: UserGetDetailUseCase {
    var result: Result<UserDetail, Error>?
    
    func getUserDetail(username: String) async throws -> UserDetail {
        guard let result = result else {
            fatalError("Result not set")
        }
        
        switch result {
        case .success(let detail):
            return detail
        case .failure(let error):
            throw error
        }
    }
}

private extension UserDetail {
    static func mock(
        id: Int = 1,
        login: String = "testUser",
        avatarUrl: String = "https://test.com/avatar.jpg",
        htmlUrl: String = "https://github.com/testUser",
        location: String? = "Test Location",
        followers: Int = 100,
        following: Int = 50
    ) -> UserDetail {
        return UserDetail(
            id: id,
            login: login,
            avatarUrl: avatarUrl,
            htmlUrl: htmlUrl,
            location: location,
            followers: followers,
            following: following
        )
    }
} 
