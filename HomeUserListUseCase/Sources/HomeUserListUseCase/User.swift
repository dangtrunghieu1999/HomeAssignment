import Foundation

public struct User: Identifiable, Equatable {
    public let id: Int
    public let login: String
    public let avatarUrl: String
    public let htmlUrl: String
    
    public init(id: Int, login: String, avatarUrl: String, htmlUrl: String) {
        self.id = id
        self.login = login
        self.avatarUrl = avatarUrl
        self.htmlUrl = htmlUrl
    }
}
