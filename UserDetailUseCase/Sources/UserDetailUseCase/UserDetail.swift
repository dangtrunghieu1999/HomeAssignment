import Foundation

public struct UserDetail: Identifiable, Equatable {
    public let id: Int
    public let login: String
    public let avatarUrl: String
    public let htmlUrl: String
    public let location: String?
    public let followers: Int
    public let following: Int
    
    public init(
        id: Int,
        login: String,
        avatarUrl: String,
        htmlUrl: String,
        location: String?,
        followers: Int,
        following: Int
    ) {
        self.id = id
        self.login = login
        self.avatarUrl = avatarUrl
        self.htmlUrl = htmlUrl
        self.location = location
        self.followers = followers
        self.following = following
    }
}
