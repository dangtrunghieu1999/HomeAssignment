import CoreData

protocol CoreDataStackProtocol {
    var context: NSManagedObjectContext { get }
    func saveContext()
}

final class CoreDataStack: CoreDataStackProtocol {
    private let persistentContainer: NSPersistentContainer
    
    init(modelName: String = "GithubUsers") {
        persistentContainer = NSPersistentContainer(name: modelName)
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
} 
