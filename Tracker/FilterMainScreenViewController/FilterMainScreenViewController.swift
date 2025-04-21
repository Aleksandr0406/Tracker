//
//  FilterMainScreenViewController.swift
//  Tracker
//
//  Created by 1111 on 09.04.2025.
//

import UIKit

final class FilterMainScreenViewController: UIViewController {
    var checkedFilterCategory: String = ""
    
    var onCategoryTodayTrackersTapped: ((String) -> ())?
    var onCategoryAllTrackersTapped: ((String) -> ())?
    var onCategoryDoneTrackersTapped: ((String) -> ())?
    var onCategoryNotDoneTrackersTapped: ((String) -> ())?
    
    private let localizableStrings: LocalizableStringsFilterMainScreenVC = LocalizableStringsFilterMainScreenVC()
    private let colorsForDarkLightTheme: ColorsForDarkLightTheme = ColorsForDarkLightTheme()
    
    private var filterCategoriesNames: [String] {
        [
            localizableStrings.categoryAllTrackers,
            localizableStrings.categoryTodayTrackers,
            localizableStrings.categoryDoneTrackers,
            localizableStrings.categoryNotDoneTrackers
        ]
    }
    
    private var filterCategoriesTable: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = colorsForDarkLightTheme.whiteBlackDLT
        
        setBarItem()
        createFilterCategoriesTable()
        setConstraints()
    }
    
    private func setBarItem() {
        navigationItem.title = localizableStrings.naviTitle
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium), NSAttributedString.Key.foregroundColor: colorsForDarkLightTheme.blackWhiteDLT]
        navigationController?.navigationBar.titleTextAttributes = attributes as [NSAttributedString.Key : Any]
    }
    
    private func createFilterCategoriesTable() {
        filterCategoriesTable.backgroundColor = colorsForDarkLightTheme.whiteBlackDLT
        filterCategoriesTable.layer.cornerRadius = 16
        filterCategoriesTable.isScrollEnabled = false
        filterCategoriesTable.tableHeaderView = UIView()
        
        filterCategoriesTable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterCategoriesTable)
        
        filterCategoriesTable.dataSource = self
        filterCategoriesTable.delegate = self
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            filterCategoriesTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            filterCategoriesTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filterCategoriesTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filterCategoriesTable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -374)
        ])
    }
}

extension FilterMainScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filterCategoriesNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let numbersOfRows = filterCategoriesNames.count
        
        if indexPath.row == numbersOfRows - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            cell.layer.masksToBounds = true
        }
        
        cell.backgroundColor = colorsForDarkLightTheme.bgAndPhBgOtherVC
        cell.textLabel?.text = filterCategoriesNames[indexPath.row]
        cell.textLabel?.textColor = colorsForDarkLightTheme.blackWhiteDLT
        
        if checkedFilterCategory == "" && cell.textLabel?.text == localizableStrings.categoryAllTrackers {
            cell.accessoryType = .checkmark
        }
        
        if cell.textLabel?.text == checkedFilterCategory {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
}

extension FilterMainScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCell = tableView.cellForRow(at: indexPath) else { return }
        
        if selectedCell.accessoryType == .none {
            selectedCell.accessoryType = .checkmark
        }
        
        guard let checkedFilterCategory = selectedCell.textLabel?.text else { return }
        if checkedFilterCategory == localizableStrings.categoryTodayTrackers {
            onCategoryTodayTrackersTapped?(checkedFilterCategory)
        }
        
        if checkedFilterCategory == localizableStrings.categoryAllTrackers {
            onCategoryAllTrackersTapped?(checkedFilterCategory)
        }
        
        if checkedFilterCategory == localizableStrings.categoryDoneTrackers {
            onCategoryDoneTrackersTapped?(checkedFilterCategory)
        }
        
        if checkedFilterCategory == localizableStrings.categoryNotDoneTrackers {
            onCategoryNotDoneTrackersTapped?(checkedFilterCategory)
        }
        
        dismiss(animated: true)
    }
}

