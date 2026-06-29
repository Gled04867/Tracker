import CoreData
import UIKit

struct TrackerStoreUpdate {
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
    let updatedIndexes: IndexSet
}

protocol TrackerStoreDelegateProtocol: AnyObject {
    func didUpdateTrackerStore(_ update: TrackerStoreUpdate)
}

final class TrackerStore: NSObject {
    private let context: NSManagedObjectContext
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    private var updatedIndexes: IndexSet?
    
    weak var delegate: TrackerStoreDelegateProtocol?
    
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCoreData.name, ascending: true)]
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        controller.delegate = self
        try? controller.performFetch()
        return controller
    }()
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func addTracker(_ tracker: Tracker, to category: TrackerCategory) throws {
        let trackerCoreData = TrackerCoreData(context: context)
        updateTracker(trackerCoreData, with: tracker)
        trackerCoreData.category = try getOrCreateCategory(category)
        try context.save()
    }

    private func getOrCreateCategory(_ category: TrackerCategory) throws -> TrackerCategoryCoreData {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.title), category.title)
        
        if let existing = try context.fetch(request).first {
            return existing
        }
        
        let newCategory = TrackerCategoryCoreData(context: context)
        newCategory.title = category.title
        return newCategory
    }
    
    private func updateTracker(_ trackerCoreData: TrackerCoreData, with tracker: Tracker) {
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.color = tracker.color
        trackerCoreData.schedule = tracker.schedule as NSObject
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
        updatedIndexes = IndexSet()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdateTrackerStore(TrackerStoreUpdate(
            insertedIndexes: insertedIndexes!,
            deletedIndexes: deletedIndexes!,
            updatedIndexes: updatedIndexes!
        ))
        insertedIndexes = nil
        deletedIndexes = nil
        updatedIndexes = nil
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath { insertedIndexes?.insert(indexPath.item) }
        case .delete:
            if let indexPath = indexPath { deletedIndexes?.insert(indexPath.item) }
        case .update:
            if let indexPath = indexPath { updatedIndexes?.insert(indexPath.item) }
        default:
            break
        }
    }
}
