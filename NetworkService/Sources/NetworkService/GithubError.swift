import Foundation

public enum GithubError: Error, Equatable {
    case networkError(Error)
    case invalidResponse
    case invalidData
    case userNotFound
    case rateLimitExceeded
    case unauthorized
    case serverError
    
    public static func == (lhs: GithubError, rhs: GithubError) -> Bool {
        switch (lhs, rhs) {
        case (.networkError(_), .networkError(_)):
            return true
        case (.invalidResponse, .invalidResponse):
            return true
        case (.invalidData, .invalidData):
            return true
        case (.userNotFound, .userNotFound):
            return true
        case (.rateLimitExceeded, .rateLimitExceeded):
            return true
        case (.unauthorized, .unauthorized):
            return true
        case (.serverError, .serverError):
            return true
        default:
            return false
        }
    }
    
    public var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from server"
        case .invalidData:
            return "Invalid data received"
        case .userNotFound:
            return "User not found"
        case .rateLimitExceeded:
            return "API rate limit exceeded. Please try again later"
        case .unauthorized:
            return "Unauthorized access"
        case .serverError:
            return "Server error occurred"
        }
    }
}
