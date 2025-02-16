
struct UserDetailDTO: Decodable {
    let id: Int
    let login: String
    let avatarUrl: String
    let htmlUrl: String
    let location: String?
    let followers: Int
    let following: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarUrl = "avatar_url"
        case htmlUrl = "html_url"
        case location
        case followers
        case following
    }
    
    func toDomain() -> UserDetail {
        UserDetail(
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
