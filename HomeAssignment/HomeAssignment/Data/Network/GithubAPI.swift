import Foundation

enum GithubAPI {
    static let baseURL = "https://api.github.com"
    
    case users(since: Int, perPage: Int)
    case userDetail(username: String)
    
    var url: URL {
        switch self {
        case .users(let since, let perPage):
            return URL(string: "\(GithubAPI.baseURL)/users?since=\(since)&per_page=\(perPage)")!
        case .userDetail(let username):
            return URL(string: "\(GithubAPI.baseURL)/users/\(username)")!
        }
    }
    
    var headers: [String: String] {
        ["Content-Type": "application/json;charset=utf-8"]
    }
} 
