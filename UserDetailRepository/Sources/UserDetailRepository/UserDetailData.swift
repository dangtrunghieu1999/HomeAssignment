import Foundation
import UserDetailUseCase

public struct UserDetailData: Decodable {
    public let id: Int
    public let login: String
    public let avatarUrl: String
    public let htmlUrl: String
    public let location: String?
    public let followers: Int
    public let following: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarUrl = "avatar_url"
        case htmlUrl = "html_url"
        case location
        case followers
        case following
    }
}


extension UserDetailData {
    func mapData() -> UserDetailUseCase.UserDetail {
        return UserDetailUseCase.UserDetail(
            id: id,
            login: login,
            avatarUrl: avatarUrl,
            htmlUrl: htmlUrl,
            location: location,
            followers: followers,
            following: following
        )
    }
}
