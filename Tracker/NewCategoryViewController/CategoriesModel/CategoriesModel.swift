//
//  Model.swift
//  Tracker
//
//  Created by 1111 on 18.03.2025.
//

import Foundation

final class CategoriesModel {
    private let localizableStrings: LocalizableStringsCategoriesModel = LocalizableStringsCategoriesModel()
    private let dataProvider: DataProvider = DataProvider()
    
    func saveCreatedCategoryNames(with newCategoryName: String) {
        dataProvider.addTrackerCategory(categoryName: newCategoryName)
    }
    
    func loadSavedCategoriesNames() -> [String] {
        dataProvider.trackerCategoryStore.trackerCategories
            .map { $0.name }
            .filter { $0 != localizableStrings.pinTrackers }
    }
}
