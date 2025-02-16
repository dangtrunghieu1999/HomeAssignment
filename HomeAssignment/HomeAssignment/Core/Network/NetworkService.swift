import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol NetworkService {
    func request<T: Decodable>(_ url: URL,
                              method: HTTPMethod,
                              headers: [String: String]?) async throws -> T
}

final class URLSessionNetworkService: NetworkService {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T: Decodable>(_ url: URL,
                              method: HTTPMethod = .get,
                              headers: [String: String]? = nil) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        headers?.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        
        NetworkLogger.shared.logRequest(request)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw GithubError.invalidResponse
        }
        
        NetworkLogger.shared.logResponse(data: data, response: response)
        
        switch httpResponse.statusCode {
        case 200...299:
            return try JSONDecoder().decode(T.self, from: data)
        case 401:
            throw GithubError.unauthorized
        case 404:
            throw GithubError.userNotFound
        case 429:
            throw GithubError.rateLimitExceeded
        case 500...599:
            throw GithubError.serverError
        default:
            throw GithubError.invalidResponse
        }
    }
} 
