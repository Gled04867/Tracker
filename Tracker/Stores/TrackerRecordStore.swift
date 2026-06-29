import CoreData
import UIKit

final class TrackerRecordStore {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func addRecord(_ record: TrackerRecord) throws {
        let recordCoreData = TrackerRecordCoreData(context: context)
        recordCoreData.id = record.id
        recordCoreData.date = Calendar.current.startOfDay(for: record.date)
        
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", record.id as NSUUID)
        if let trackerCoreData = try context.fetch(request).first {
            recordCoreData.tracker = trackerCoreData
        }
        
        try context.save()
    }

    func deleteRecord(_ record: TrackerRecord) throws {
        let request = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(
            format: "id == %@ AND date == %@",
            record.id as NSUUID,
            Calendar.current.startOfDay(for: record.date) as NSDate
        )
        if let recordCoreData = try context.fetch(request).first {
            context.delete(recordCoreData)
            try context.save()
        }
    }
    
    func isTrackerCompleted(_ trackerId: UUID, on date: Date) -> Bool {
        let request = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(
            format: "id == %@ AND date == %@",
            trackerId as NSUUID,
            Calendar.current.startOfDay(for: date) as NSDate
        )
        return (try? context.fetch(request).first) != nil
    }
    
    func completedDays(for trackerId: UUID) -> Int {
        let request = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", trackerId as NSUUID)
        return (try? context.fetch(request))?.count ?? 0
    }
}
