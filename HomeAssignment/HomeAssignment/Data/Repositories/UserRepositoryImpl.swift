
final class UserRepositoryImpl: UserRepository {
    private let networkService: NetworkService
    private let storage: UserStorage
    
    init(networkService: NetworkService, storage: UserStorage) {
        self.networkService = networkService
        self.storage = storage
    }
    
    func getUsers(since: Int, perPage: Int) async throws -> [User] {
        let api = GithubAPI.users(since: since, perPage: perPage)
        
        do {
            let response: [UserDTO] = try await networkService.request(api.url, method: .get, headers: api.headers)
            let users = response.map { $0.toDomain() }
            await storage.save(users)
            return users
        } catch {
            if let users = try? await storage.getUsers() {
                return users
            }
            throw error
        }
    }
    
    func getUserDetail(username: String) async throws -> UserDetail {
        let api = GithubAPI.userDetail(username: username)
        let response: UserDetailDTO = try await networkService.request(api.url, method: .get, headers: api.headers)
        return response.toDomain()
    }
} 
