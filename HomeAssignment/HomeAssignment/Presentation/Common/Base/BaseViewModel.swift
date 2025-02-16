import Foundation

class BaseViewModel: ObservableObject {
    @Published private(set) var viewState: ViewState = BaseViewState()
    
    func startLoading() {
        viewState.isLoading = true
        viewState.error = nil
    }
    
    func stopLoading() {
        viewState.isLoading = false
    }
    
    func handleError(_ error: Error) {
        viewState.isLoading = false
        viewState.error = error
    }
} 
