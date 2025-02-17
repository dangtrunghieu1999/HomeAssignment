import Foundation

public protocol UserGetDetailUseCase {
    func getUserDetail(username: String) async throws -> UserDetail
}

public final class UserDetailUseCaseImpl: UserGetDetailUseCase {
    private let repository: UserDetailRepository
    
    public init(repository: UserDetailRepository) {
        self.repository = repository
    }
    
    public func getUserDetail(username: String) async throws -> UserDetail {
        try await repository.getUserDetail(username: username)
    }
}
