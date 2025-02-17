import Foundation
import HomeUserListUseCase
import NetworkService

public final class HomeUserListRepositoryImpl: HomeUserListRepository {
    private let networkService: NetworkService

    public init(networkService: NetworkService) {
        self.networkService = networkService
    }

    public func getUsers(since: Int, perPage: Int) async throws -> [HomeUserListUseCase.User] {
        let api = GithubAPI.users(since: since, perPage: perPage)

        do {
            let response: [UserData] = try await networkService.request(api.url, method: .get, headers: api.headers)
            let users = response.map { $0.mapData() }
            return users
        } catch {
            throw error
        }
    }
}
