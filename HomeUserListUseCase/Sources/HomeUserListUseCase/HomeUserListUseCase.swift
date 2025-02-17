import Foundation

public protocol HomeGetUsersUseCase {
    func fetchUserList(since: Int, perPage: Int) async throws -> [User]
}

public final class HomeGetUsersUseCaseImpl: HomeGetUsersUseCase {
    private let repository: HomeUserListRepository

    public init(repository: HomeUserListRepository) {
        self.repository = repository
    }

    public func fetchUserList(since: Int, perPage: Int) async throws -> [User] {
        try await repository.getUsers(since: since, perPage: perPage)
    }
}
