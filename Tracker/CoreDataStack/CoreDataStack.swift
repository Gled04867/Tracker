import CoreData
import Logging

final class CoreDataStack {
    static let shared = CoreDataStack()
    
    private let logger = Logger(label: "com.Tracker.CoreDataStack")
    
    private init(){}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Tracker")
        container.loadPersistentStores(completionHandler: {(storeDescription, error) in
            if let error = error as NSError? {
                self.logger.critical("Unresolved error \(error.localizedDescription), userInfo: \(error.userInfo)")
                assertionFailure("\(error.localizedDescription), userInfo: \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
                let error = error as NSError
                logger.error("Core Data save error: \(error), \(error.userInfo)")
            }
        }
    }
}
