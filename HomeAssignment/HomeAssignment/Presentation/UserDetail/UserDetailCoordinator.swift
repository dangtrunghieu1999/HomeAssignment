import UIKit

final class UserDetailCoordinator: Coordinator {
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private let username: String
    private let networkService: NetworkService
    private let storage: UserStorage
    private let coreDataStack: CoreDataStackProtocol

    init(
        navigationController: UINavigationController,
        username: String,
        networkService: NetworkService = URLSessionNetworkService(),
        coreDataStack: CoreDataStackProtocol = CoreDataStack()
    ) {
        self.navigationController = navigationController
        self.username = username
        self.networkService = networkService
        self.coreDataStack = coreDataStack
        self.storage = CoreDataUserStorage(coreDataStack: coreDataStack)
    }
    
    func start() {
        let repository = UserRepositoryImpl(networkService: networkService, storage: storage)
        let getUserDetailUseCase = GetUserDetailUseCaseImpl(repository: repository)
        let viewModel = UserDetailViewModel(username: username, getUserDetailUseCase: getUserDetailUseCase)
        let viewController = UserDetailViewController(viewModel: viewModel)
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
} 
