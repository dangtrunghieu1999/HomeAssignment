import Foundation

protocol ErrorHandling {
    func handle(_ error: Error) -> String
}

final class ErrorHandler: ErrorHandling {
    static let shared = ErrorHandler()
    
    func handle(_ error: Error) -> String {
        switch error {
        case let githubError as GithubError:
            return handleGithubError(githubError)
        case let urlError as URLError:
            return handleURLError(urlError)
        default:
            return error.localizedDescription
        }
    }
    
    private func handleGithubError(_ error: GithubError) -> String {
        switch error {
        case .rateLimitExceeded:
            return "Rate limit exceeded. Please try again later."
        case .userNotFound:
            return "User not found."
        case .networkError:
            return "Network error occurred. Please check your connection."
        default:
            return error.localizedDescription
        }
    }
    
    private func handleURLError(_ error: URLError) -> String {
        switch error.code {
        case .notConnectedToInternet:
            return "No internet connection. Please check your network settings."
        case .timedOut:
            return "Request timed out. Please try again."
        default:
            return "Network error occurred."
        }
    }
} 
