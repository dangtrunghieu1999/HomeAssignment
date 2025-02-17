import UIKit
import NetworkService
import HomeUerListRepository
import HomeUserListUseCase

final class UserListCoordinator: Coordinator {
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private let networkService: NetworkService
    
    init(
        navigationController: UINavigationController,
        networkService: NetworkService = URLSessionNetworkService()
    ) {
        self.navigationController = navigationController
        self.networkService = networkService
    }
    
    func start() {
        let repository = HomeUserListRepositoryImpl(networkService: networkService)
        let getUsersUseCase = HomeGetUsersUseCaseImpl(repository: repository)
        let viewModel = UserListViewModel(getUsersUseCase: getUsersUseCase)
        let viewController = UserListViewController(viewModel: viewModel)
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showUserDetail(username: String) {
        let userDetailCoordinator = UserDetailCoordinator(
            navigationController: navigationController,
            username: username,
            networkService: networkService
        )
        userDetailCoordinator.parentCoordinator = self
        childCoordinators.append(userDetailCoordinator)
        userDetailCoordinator.start()
    }
} 
