import CoreData
import Combine

protocol UserStorage {
    func save(_ users: [User]) async
    func getUsers() async throws -> [User]
}

final class CoreDataUserStorage: UserStorage {
    private let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack = .shared) {
        self.coreDataStack = coreDataStack
    }
    
    func save(_ users: [User]) async {
        let context = coreDataStack.context
        
        await context.perform {
            users.forEach { user in
                let entity = UserEntity(context: context)
                entity.id = Int64(user.id)
                entity.login = user.login
                entity.avatarUrl = user.avatarUrl
                entity.htmlUrl = user.htmlUrl
            }
            
            self.coreDataStack.saveContext()
        }
    }
    
    func getUsers() async throws -> [User] {
        try await coreDataStack.context.perform {
            let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
            
            let entities = try self.coreDataStack.context.fetch(request)
            return entities.map { entity in
                User(
                    id: Int(entity.id),
                    login: entity.login ?? "",
                    avatarUrl: entity.avatarUrl ?? "",
                    htmlUrl: entity.htmlUrl ?? ""
                )
            }
        }
    }
} 
