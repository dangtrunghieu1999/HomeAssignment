import UIKit

final class UserDetailCoordinator: Coordinator {
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private let username: String
    private let networkService: NetworkService
    
    init(navigationController: UINavigationController,
         username: String,
         networkService: NetworkService = URLSessionNetworkService()) {
        self.navigationController = navigationController
        self.username = username
        self.networkService = networkService
    }
    
    func start() {
        let repository = UserRepositoryImpl(networkService: networkService, storage: CoreDataUserStorage())
        let getUserDetailUseCase = GetUserDetailUseCaseImpl(repository: repository)
        let viewModel = UserDetailViewModel(username: username, getUserDetailUseCase: getUserDetailUseCase)
        let viewController = UserDetailViewController(viewModel: viewModel)
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
} 
