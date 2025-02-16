import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showUserList()
    }
    
    private func showUserList() {
        let userListCoordinator = UserListCoordinator(navigationController: navigationController)
        userListCoordinator.parentCoordinator = self
        childCoordinators.append(userListCoordinator)
        userListCoordinator.start()
    }
} 
