import Foundation
import HomeUserListUseCase

public struct UserRepository: Decodable {
    let id: Int
    let login: String
    let avatarUrl: String
    let htmlUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarUrl = "avatar_url"
        case htmlUrl = "html_url"
    }
}

extension UserRepository {
    func mapData() -> HomeUserListUseCase.User {
        return HomeUserListUseCase.User(
            id: id,
            login: login,
            avatarUrl: avatarUrl,
            htmlUrl: htmlUrl
        )
    }
}
