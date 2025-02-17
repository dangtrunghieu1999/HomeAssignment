import Foundation
import HomeUserListUseCase

public struct UserData: Decodable {
    public let id: Int
    public let login: String
    public let avatarUrl: String
    public let htmlUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarUrl = "avatar_url"
        case htmlUrl = "html_url"
    }
}

extension UserData {
    func mapData() -> HomeUserListUseCase.User {
        return HomeUserListUseCase.User(
            id: id,
            login: login,
            avatarUrl: avatarUrl,
            htmlUrl: htmlUrl
        )
    }
}
