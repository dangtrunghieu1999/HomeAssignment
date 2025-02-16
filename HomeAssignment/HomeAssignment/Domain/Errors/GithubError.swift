import Foundation

enum GithubError: LocalizedError {
    case networkError(Error)
    case invalidResponse
    case invalidData
    case userNotFound
    case rateLimitExceeded
    case unauthorized
    case serverError
    
    var errorDescription: String? {
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