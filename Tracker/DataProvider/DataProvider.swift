//
//  DataProvider.swift
//  Tracker
//
//  Created by 1111 on 12.03.2025.
//

import CoreData

final class DataProvider: NSObject {
    let trackerCategoryStore: TrackerCategoryStore = TrackerCategoryStore()
    private let trackerStore: TrackerStore = TrackerStore()
    private let trackerRecordStore: TrackerRecordStore = TrackerRecordStore()
    
    private var context: NSManagedObjectContext? {
        DataBaseStore.shared.persistentContainer.viewContext
    }
    
    func getCategoryName(id: UUID) -> String {
        trackerStore.getCategoryName(id: id)
    }
    
    func getAllTrackers() -> [Tracker] {
        trackerStore.getAllTrackers()
    }
    
    func addTrackerCategory(categoryName: String) {
        guard let context = context else { return }
        
        let categoryIsExist = trackerCategoryStore.checkCategoryExistence(categoryName: categoryName)
        
        if  categoryIsExist != nil {
            print("This category is already exist")
        } else {
            let trackerCategory = TrackerCategoryCoreData(context: context)
            trackerCategory.name = categoryName
            try? context.save()
        }
    }
    
    func addTracker(categoryName: String, tracker: Tracker) {
        guard let context = context else { return }
        
        if let categoryIsExist = trackerCategoryStore.checkCategoryExistence(categoryName: categoryName) {
            do {
                try trackerStore.addNewTracker(category: categoryIsExist, tracker: tracker)
            } catch {
                print("Cant save newTracker")
            }
        } else {
            let trackerCategory = TrackerCategoryCoreData(context: context)
            trackerCategory.name = categoryName
            try? context.save()
            do {
                try trackerStore.addNewTracker(category: trackerCategory, tracker: tracker)
            } catch {
                print("Cant add tracker to category")
            }
        }
    }
    
    func unPinTracker(id: UUID) {
        trackerStore.unPinTracker(id: id)
    }
    
    func removeTracker(id: UUID) {
        trackerStore.remove(id)
    }
    
    func updateTracker(updatingTracker: Tracker, updateCategoryName: String) {
        guard let categoryIsExist = trackerCategoryStore.checkCategoryExistence(categoryName: updateCategoryName) else { return }
        
        do {
            try trackerStore.updateTracker(updatingTracker: updatingTracker, updateCategoryName: categoryIsExist)
        } catch {
            print("Cant update newTracker")
        }
    }
    
    func addTrackerRecord(trackerRecord: TrackerRecord) {
        let recordIsExist = trackerRecordStore.checkRecordExistence(trackerRecord: trackerRecord)
        if recordIsExist {
            print("This record exist")
        } else {
            do {
                try trackerRecordStore.addNewTrackerRecord(trackerRecord)
            } catch {
                print("Cant store trackerRecord")
            }
        }
    }
    
    func remove(_ trackerRecord: TrackerRecord) {
        let recordIsExist = trackerRecordStore.checkRecordExistence(trackerRecord: trackerRecord)
        if recordIsExist {
            trackerRecordStore.remove(trackerRecord)
        } else {
            print("That record doesn't exist")
        }
    }
}

