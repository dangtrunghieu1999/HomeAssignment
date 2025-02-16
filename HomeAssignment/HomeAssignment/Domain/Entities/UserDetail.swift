import Foundation

struct UserDetail: Identifiable {
    let id: Int
    let login: String
    let avatarUrl: String
    let htmlUrl: String
    let location: String?
    let followers: Int
    let following: Int
} 