//
//  TrackerStore.swift
//  Tracker
//
//  Created by 1111 on 11.03.2025.
//

import CoreData

enum TrackerStoreError: Error {
    case decodingErrorInvalidId
    case decodingErrorInvalidName
    case decodingErrorInvalidColor
    case decodingErrorInvalidEmoji
    case decodingErrorInvalidSchedule
}

final class TrackerStore: NSObject {
    private let localizableStrings: LocalizableStringsTrackerStore = LocalizableStringsTrackerStore()
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
        let context = DataBaseStore.shared.persistentContainer.viewContext
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
        fetchedResultsController = controller
        try controller.performFetch()
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
    
    func getCategoryName(id: UUID) -> String {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let objects = try? context.fetch(fetchRequest)
        let neededTrackerCategoryCoreData = objects?.first { $0.id == id && $0.category?.name != localizableStrings.pinTrackers } ?? TrackerCoreData()
        guard let categoryName = neededTrackerCategoryCoreData.category?.name else { return "" }
        return categoryName
    }
    
    func getAllTrackers() -> [Tracker] {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let objects = try? context.fetch(fetchRequest)
        let allTrackers = (try? objects?.compactMap { try trackerFetch(from: $0) }) ?? []
        return allTrackers
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
    
    func updateTracker(updatingTracker: Tracker, updateCategoryName: TrackerCategoryCoreData) throws {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let trackers = try? context.fetch(fetchRequest)
        
        let updatingStoreTrackers = trackers?.filter {
            $0.id == updatingTracker.id
        }
        
        updatingStoreTrackers?.forEach {
            
            if $0.category?.name != localizableStrings.pinTrackers {
                $0.category = updateCategoryName
            }
            
            $0.name = updatingTracker.name
            $0.color = updatingTracker.color
            $0.emoji = updatingTracker.emoji
            $0.schedule = updatingTracker.schedule as NSObject
            
            try? context.save()
        }
    }
    
    func unPinTracker(id: UUID) {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let trackers = try? context.fetch(fetchRequest)
        guard let trackerToUnpin = trackers?.first(where: {
            $0.id == id && $0.category?.name == localizableStrings.pinTrackers
        }) else { return }
        
        context.delete(trackerToUnpin)
        try? context.save()
    }
    
    func remove(_ id: UUID) {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let allTrackers = try? context.fetch(fetchRequest)
        let trackersToRemove = allTrackers?.filter { $0.id == id }
        
        trackersToRemove?.forEach {
            context.delete($0)
            try? context.save()
        }
    }
}


