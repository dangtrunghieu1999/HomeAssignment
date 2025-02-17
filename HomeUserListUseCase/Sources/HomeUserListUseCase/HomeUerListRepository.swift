import Foundation

public protocol HomeUserListRepository {
    func getUsers(since: Int, perPage: Int) async throws -> [User]
}
