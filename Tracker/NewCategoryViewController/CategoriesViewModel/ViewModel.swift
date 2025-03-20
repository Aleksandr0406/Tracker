//
//  ViewModel.swift
//  Tracker
//
//  Created by 1111 on 18.03.2025.
//

import Foundation

final class CategoriesViewModel {
    var newCategoryNamesCreated: (() -> Void)?
    
    private let model: CategoriesModel = CategoriesModel()
    
    func didCreateNewCategory(with newCategoryName: String) {
        model.saveCreatedCategoryNames(with: newCategoryName)
        guard let newCategoryNamesCreated = newCategoryNamesCreated else { return }
        newCategoryNamesCreated()
    }
    
    func loadSavedCategoriesNames() -> [String] {
        let categoryNames = model.loadSavedCategoriesNames()
        return categoryNames
    }
}
