//
//  PersistentContainer.swift
//  Tracker
//
//  Created by 1111 on 15.04.2025.
//

import Foundation
import CoreData

final class DataBaseStore {
    static let shared = DataBaseStore()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Tracker")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private init() {}
}
