import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

public protocol NetworkService {
    func request<T: Decodable>(_ url: URL,
                               method: HTTPMethod,
                               headers: [String: String]?) async throws -> T
}

public protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol { }

public final class URLSessionNetworkService: NetworkService {
    private let session: URLSessionProtocol
    private let logger: NetworkLogging
    
    public init(session: URLSessionProtocol = URLSession.shared, logger: NetworkLogging = NetworkLogger()) {
        self.session = session
        self.logger = logger
    }
    
    public func request<T: Decodable>(_ url: URL,
                                      method: HTTPMethod = .get,
                                      headers: [String: String]? = nil) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        headers?.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        
        logger.logRequest(request)
        
        let (data, response): (Data, URLResponse)
        
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            logger.logError(error, statusCode: nil)
            throw error
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            let error = GithubError.invalidResponse
            logger.logError(error, statusCode: nil)
            throw error
        }
        
        logger.logResponse(data: data, response: response)
        
        let statusCode = httpResponse.statusCode
        let error: GithubError
        
        switch statusCode {
        case 200...299:
            return try JSONDecoder().decode(T.self, from: data)
        case 401:
            error = .unauthorized
        case 404:
            error = .userNotFound
        case 429:
            error = .rateLimitExceeded
        case 500...599:
            error = .serverError
        default:
            error = .invalidResponse
        }
        
        logger.logError(error, statusCode: statusCode)
        throw error
    }
}
