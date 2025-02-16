
protocol ViewState {
    var isLoading: Bool { get set }
    var error: Error? { get set }
}

struct BaseViewState: ViewState {
    var isLoading: Bool = false
    var error: Error? = nil
}

struct ListViewState<T>: ViewState {
    var isLoading: Bool = false
    var error: Error? = nil
    var items: [T] = []
    var hasMorePages: Bool = true
}

struct DetailViewState<T>: ViewState {
    var isLoading: Bool = false
    var error: Error? = nil
    var data: T?
} 
