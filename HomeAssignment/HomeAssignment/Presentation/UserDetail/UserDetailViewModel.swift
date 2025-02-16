import Combine
import Foundation

final class UserDetailViewModel: BaseViewModel {
    // MARK: - Properties
    private let getUserDetailUseCase: GetUserDetailUseCase
    private let username: String
    
    @Published private(set) var detailState: DetailViewState<UserDetail> = DetailViewState()
    
    // MARK: - Init
    init(username: String, getUserDetailUseCase: GetUserDetailUseCase) {
        self.username = username
        self.getUserDetailUseCase = getUserDetailUseCase
        super.init()
    }
    
    // MARK: - Public Methods
    func loadUserDetail() async {
        startLoading()
        
        do {
            let userDetail = try await getUserDetailUseCase.execute(username: username)
            stopLoading()
            detailState.data = userDetail
        } catch {
            handleError(error)
        }
    }
    
    func refresh() async {
        detailState.data = nil
        await loadUserDetail()
    }
} 
