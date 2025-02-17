import Foundation

public protocol NetworkLogging {
    func logRequest(_ request: URLRequest)
    func logResponse(data: Data, response: URLResponse)
    func logError(_ error: Error, statusCode: Int?)
}

public final class NetworkLogger: NetworkLogging {

    public init() {}
    
    public func logRequest(_ request: URLRequest) {
        #if DEBUG
        print("\n🌐 =================== Network Request ===================")
        print("URL: \(request.url?.absoluteString ?? "Invalid URL")")
        print("Method: \(request.httpMethod ?? "Unknown")")
        if let headers = request.allHTTPHeaders {
            print("Headers: \(headers)")
        }
        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            print("Body: \(bodyString)")
        }
        print("=====================================================\n")
        #endif
    }
    
    public func logResponse(data: Data, response: URLResponse) {
        #if DEBUG
        print("\n📥 =================== Network Response ==================")
        if let httpResponse = response as? HTTPURLResponse {
            print("Status Code: \(httpResponse.statusCode)")
            print("Headers: \(httpResponse.allHeaderFields)")
        }
        
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Response Body: \(jsonString)")
        }
        print("=====================================================\n")
        #endif
    }
    
    public func logError(_ error: Error, statusCode: Int? = nil) {
        #if DEBUG
        print("\n❌ =================== Network Error ====================")
        if let statusCode = statusCode {
            print("Status Code: \(statusCode)")
        }
        print("Error: \(error.localizedDescription)")
        print("=====================================================\n")
        #endif
    }
}

public extension URLRequest {
    var allHTTPHeaders: [String: String]? {
        allHTTPHeaderFields
    }
}
