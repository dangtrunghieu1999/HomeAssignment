import Foundation

public protocol UserDetailRepository {
    func getUserDetail(username: String) async throws -> UserDetail
}
