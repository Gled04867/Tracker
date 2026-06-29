import CoreData
import UIKit

struct TrackerCategoryStoreUpdate {
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
    let updatedIndexes: IndexSet
}

protocol TrackerCategoryStoreDelegateProtocol: AnyObject {
    func didUpdateTrackerCategoryStore(_ update: TrackerCategoryStoreUpdate)
}

final class TrackerCategoryStore: NSObject {
    private let context: NSManagedObjectContext
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    private var updatedIndexes: IndexSet?
    
    weak var delegate: TrackerCategoryStoreDelegateProtocol?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCategoryCoreData.title, ascending: true)]
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
    
    var categories: [TrackerCategory] {
        guard let objects = fetchedResultsController.fetchedObjects else { return [] }
        return objects.compactMap { categoryCoreData in
            guard let title = categoryCoreData.title,
                  let trackersSet = categoryCoreData.tracker as? Set<TrackerCoreData> else { return nil }
            
            let trackers = trackersSet.compactMap { trackerCoreData -> Tracker? in
                guard let id = trackerCoreData.id,
                      let name = trackerCoreData.name,
                      let emoji = trackerCoreData.emoji,
                      let color = trackerCoreData.color as? UIColor,
                      let schedule = trackerCoreData.schedule as? [WeekDay] else { return nil }
                return Tracker(id: id, name: name, emoji: emoji, color: color, schedule: schedule)
            }
            return TrackerCategory(title: title, trackers: trackers)
        }
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
        updatedIndexes = IndexSet()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdateTrackerCategoryStore(TrackerCategoryStoreUpdate(
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
