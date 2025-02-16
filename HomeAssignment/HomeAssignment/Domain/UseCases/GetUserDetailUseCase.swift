import Combine

protocol GetUserDetailUseCase {
    func execute(username: String) async throws -> UserDetail
}

final class GetUserDetailUseCaseImpl: GetUserDetailUseCase {
    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func execute(username: String) async throws -> UserDetail {
        try await repository.getUserDetail(username: username)
    }
} 