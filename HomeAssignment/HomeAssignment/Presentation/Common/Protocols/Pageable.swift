protocol Pageable {
    var currentPage: Int { get set }
    var perPage: Int { get }
    var isLoading: Bool { get set }
    var hasMorePages: Bool { get set }
    
    func loadNextPage()
    func resetPagination()
}

