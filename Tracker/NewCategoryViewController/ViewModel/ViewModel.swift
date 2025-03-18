//
//  ViewModel.swift
//  Tracker
//
//  Created by 1111 on 18.03.2025.
//

import Foundation

final class ViewModel {
    var newCategoryNamesCreated: (() -> Void)?
    
    private let model: Model = Model()
    
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
