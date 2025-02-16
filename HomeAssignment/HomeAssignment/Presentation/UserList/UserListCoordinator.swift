import UIKit

final class UserListCoordinator: Coordinator {
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private let networkService: NetworkService
    private let storage: UserStorage
    private let coreDataStack: CoreDataStackProtocol
    
    init(
        navigationController: UINavigationController,
        networkService: NetworkService = URLSessionNetworkService(),
        coreDataStack: CoreDataStackProtocol = CoreDataStack()
    ) {
        self.navigationController = navigationController
        self.networkService = networkService
        self.coreDataStack = coreDataStack
        self.storage = CoreDataUserStorage(coreDataStack: coreDataStack)
    }
    
    func start() {
        let repository = UserRepositoryImpl(networkService: networkService, storage: storage)
        let getUsersUseCase = GetUsersUseCaseImpl(repository: repository)
        let viewModel = UserListViewModel(getUsersUseCase: getUsersUseCase, repository: repository)
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
