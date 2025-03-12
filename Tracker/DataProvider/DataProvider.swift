//
//  DataProvider.swift
//  Tracker
//
//  Created by 1111 on 12.03.2025.
//

import CoreData
import UIKit

final class DataProvider: NSObject {
    private let trackerStore: TrackerStore = TrackerStore()
    private let trackerCategoryStore: TrackerCategoryStore = TrackerCategoryStore()
    private let trackerRecordStore: TrackerRecordStore = TrackerRecordStore()
    
    private var context: NSManagedObjectContext? {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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
    
    func addTrackerRecord(trackerRecord: TrackerRecord) {
        let recordIsExist = trackerRecordStore.checkRecordExistence(trackerRecord: trackerRecord)
        if recordIsExist {
            print("This record exist")
        } else {
            try! trackerRecordStore.addNewTrackerRecord(trackerRecord)
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
