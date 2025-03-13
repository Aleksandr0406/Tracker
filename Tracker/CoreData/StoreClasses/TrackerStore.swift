//
//  TrackerStore.swift
//  Tracker
//
//  Created by 1111 on 11.03.2025.
//

import CoreData
import UIKit

enum TrackerStoreError: Error {
    case decodingErrorInvalidId
    case decodingErrorInvalidName
    case decodingErrorInvalidColor
    case decodingErrorInvalidEmoji
    case decodingErrorInvalidSchedule
}

final class TrackerStore: NSObject {
    private let uiColorMarshalling: UIColorMarshalling = UIColorMarshalling()
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>?
    
    var trackers: [Tracker] {
        guard
            let objects = self.fetchedResultsController?.fetchedObjects,
            let trackers = try? objects.map({ try self.trackerFetch(from: $0) })
        else { return [] }
        return trackers
    }
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext ?? NSManagedObjectContext()
        try! self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.name, ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        self.fetchedResultsController = controller
        try controller.performFetch()
    }
    
    func addNewTracker(category: TrackerCategoryCoreData, tracker: Tracker) throws {
        let trackerCoreData = TrackerCoreData(context: context)
        
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.color = tracker.color
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = tracker.schedule as NSObject
        trackerCoreData.category = category
        try context.save()
    }
    
    func trackerFetch(from trackerCoreData: TrackerCoreData) throws -> Tracker {
        guard let name = trackerCoreData.name else {
            throw TrackerStoreError.decodingErrorInvalidName
        }
        
        guard let id = trackerCoreData.id else {
            throw TrackerStoreError.decodingErrorInvalidId
        }
        
        guard let color = trackerCoreData.color else {
            throw TrackerStoreError.decodingErrorInvalidColor
        }
        
        guard let emoji = trackerCoreData.emoji else {
            throw TrackerStoreError.decodingErrorInvalidEmoji
        }
        
        guard let schedule = trackerCoreData.schedule as? [Int] else {
            throw TrackerStoreError.decodingErrorInvalidSchedule
        }
        
        return Tracker(id: id, name: name, color: color, emoji: emoji, schedule: schedule)
    }
}
