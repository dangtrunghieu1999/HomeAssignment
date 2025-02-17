import Foundation
import UserDetailUseCase
import NetworkService

public final class UserDetailRepositoryImpl: UserDetailRepository {
    private let networkService: NetworkService
    
    public init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    public func getUserDetail(username: String) async throws -> UserDetailUseCase.UserDetail {
        let api = GithubAPI.userDetail(username: username)
        let response: UserDetailData = try await networkService.request(api.url, method: .get, headers: api.headers)
        return response.mapData()
    }
}
