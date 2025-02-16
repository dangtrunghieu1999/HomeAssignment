import Combine

protocol UserRepository {
    func getUsers(since: Int, perPage: Int) async throws -> [User]
    func getUserDetail(username: String) async throws -> UserDetail
} 