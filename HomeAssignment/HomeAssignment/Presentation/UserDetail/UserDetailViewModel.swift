import Combine
import Foundation
import UserDetailUseCase

final class UserDetailViewModel: BaseViewModel {
    // MARK: - Properties
    private let getUserDetailUseCase: UserGetDetailUseCase
    private let username: String
    
    @Published private(set) var detailState: DetailViewState<UserDetail> = DetailViewState()
    
    // MARK: - Init
    init(username: String, getUserDetailUseCase: UserGetDetailUseCase) {
        self.username = username
        self.getUserDetailUseCase = getUserDetailUseCase
        super.init()
    }
    
    // MARK: - Public Methods
    func loadUserDetail() async {
        startLoading()
        
        do {
            let userDetail = try await getUserDetailUseCase.getUserDetail(username: username)
            stopLoading()
            detailState.data = userDetail
        } catch {
            stopLoading()
            detailState.error = error
            detailState.data = nil
        }
    }
    
    func refresh() async {
        detailState.data = nil
        await loadUserDetail()
    }
} 
