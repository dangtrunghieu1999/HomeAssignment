import Combine

protocol GetUsersUseCase {
    func execute(since: Int, perPage: Int) async throws -> [User]
}

final class GetUsersUseCaseImpl: GetUsersUseCase {
    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func execute(since: Int, perPage: Int) async throws -> [User] {
        try await repository.getUsers(since: since, perPage: perPage)
    }
} 