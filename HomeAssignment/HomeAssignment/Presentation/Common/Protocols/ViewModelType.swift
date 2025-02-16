import Combine

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

protocol ViewModelState {
    var isLoading: Bool { get }
    var error: Error? { get }
} 