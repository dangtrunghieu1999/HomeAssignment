import Foundation
import HomeUserListUseCase

final class UserListViewModel: BaseViewModel {
    // MARK: - Types
    enum State: Equatable {
        case idle
        case loading
        case loaded([User])
        case error(Error)
        
        static func == (lhs: State, rhs: State) -> Bool {
            switch (lhs, rhs) {
            case (.idle, .idle):
                return true
            case (.loading, .loading):
                return true
            case let (.loaded(lhsUsers), .loaded(rhsUsers)):
                return lhsUsers == rhsUsers
            case (.error, .error):
                return true
            default:
                return false
            }
        }
    }
    
    // MARK: - Properties
    private let getUsersUseCase: HomeGetUsersUseCase
    private var currentPage = 0
    private let perPage = 20
    private var hasMorePages = true
    
    // MARK: - Published Properties
    @Published private(set) var state: State = .idle
    @Published private(set) var users: [User] = []
    
    // MARK: - Init
    init(getUsersUseCase: HomeGetUsersUseCase) {
        self.getUsersUseCase = getUsersUseCase
        super.init()
    }
    
    // MARK: - Public Methods
    func viewDidLoad() async {
        await loadData(page: 0)
    }
    
    func loadMore() async {
        guard !viewState.isLoading && hasMorePages else { return }
        await loadData(page: currentPage)
    }
    
    func refresh() async {
        currentPage = 0
        users.removeAll()
        hasMorePages = true
        await loadData(page: 0)
    }
    
    // MARK: - Private Methods
    private func loadData(page: Int) async {
        startLoading()
        state = .loading
          
        do {
            let since = page * perPage
            let newUsers = try await getUsersUseCase.fetchUserList(since: since, perPage: perPage)
            users.append(contentsOf: newUsers)
            currentPage += 1
            hasMorePages = newUsers.count == perPage
            state = .loaded(users)
        } catch {
            state = .error(error)
            handleError(error)
        }
        
        stopLoading()
    }
} 
