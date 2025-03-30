//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by 1111 on 11.02.2025.
//

import UIKit

final class NewTrackerViewController: UIViewController {
    var onAddHabitOrNonRegularEvenButtonTapped: (((String, String, [String], String, UIColor) -> ()))?
    
    private let localizableStrings: LocalizableStringsNewTrackerVC = LocalizableStringsNewTrackerVC()
    private let colorsForDarkLightTheme: ColorsForDarkLightTheme = ColorsForDarkLightTheme()
    private let addNewTrackerButton: UIButton = UIButton()
    private let addNewNotRegularEventButton: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = colorsForDarkLightTheme.whiteBlackDLT
        
        setBarItem()
        createAddNewHabitButton()
        createAddNewNotRegularEventButton()
        setConstraints()
    }
    
    private func setBarItem() {
        navigationItem.title = localizableStrings.title
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium), NSAttributedString.Key.foregroundColor: colorsForDarkLightTheme.blackWhiteDLT]
        navigationController?.navigationBar.titleTextAttributes = attributes
    }
    
    private func createAddNewHabitButton() {
        addNewTrackerButton.layer.cornerRadius = 16
        addNewTrackerButton.backgroundColor = colorsForDarkLightTheme.blackWhiteDLT
        addNewTrackerButton.setTitle(localizableStrings.addNewHabitButtonTitle, for: .normal)
        addNewTrackerButton.setTitleColor(colorsForDarkLightTheme.whiteBlackDLT, for: .normal)
        addNewTrackerButton.titleLabel?.textAlignment = .center
        addNewTrackerButton.titleLabel?.font = .systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        
        addNewTrackerButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addNewTrackerButton)
        
        addNewTrackerButton.addTarget(self, action: #selector(didTapAddNewHabitButton), for: .touchUpInside)
    }
    
    @objc private func didTapAddNewHabitButton() {
        let sections = [localizableStrings.categoryLoc, localizableStrings.scheduleLoc]
        presentHabitOrNotRegularEvent(sections)
    }
    
    private func createAddNewNotRegularEventButton() {
        addNewNotRegularEventButton.layer.cornerRadius = 16
        addNewNotRegularEventButton.backgroundColor = colorsForDarkLightTheme.blackWhiteDLT
        addNewNotRegularEventButton.setTitle(localizableStrings.addNewNotRegularEventButton, for: .normal)
        addNewNotRegularEventButton.setTitleColor(colorsForDarkLightTheme.whiteBlackDLT, for: .normal)
        addNewNotRegularEventButton.titleLabel?.textAlignment = .center
        addNewNotRegularEventButton.titleLabel?.font = .systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        
        addNewNotRegularEventButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addNewNotRegularEventButton)
        
        addNewNotRegularEventButton.addTarget(self, action: #selector(didTapAddNewNotRegularEventButton), for: .touchUpInside)
    }
    
    @objc private func didTapAddNewNotRegularEventButton() {
        let sections = [localizableStrings.categoryLoc]
        presentHabitOrNotRegularEvent(sections)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            addNewTrackerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -357),
            addNewTrackerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addNewTrackerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addNewTrackerButton.heightAnchor.constraint(equalToConstant: 60),
            
            addNewNotRegularEventButton.topAnchor.constraint(equalTo: addNewTrackerButton.bottomAnchor, constant: 16),
            addNewNotRegularEventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addNewNotRegularEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addNewNotRegularEventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func presentHabitOrNotRegularEvent(_ sections: [String]) {
        let viewcontroller = NewHabitOrNonRegularEventViewController()
        viewcontroller.onAddHabitButtonTapped = { [weak self] savedHabitName, savedCategoryName, savedDays, savedEmoji, savedColor in
            guard let onAddHabitOrNonRegularEvenButtonTapped = self?.onAddHabitOrNonRegularEvenButtonTapped else { return }
            onAddHabitOrNonRegularEvenButtonTapped(savedHabitName, savedCategoryName, savedDays, savedEmoji, savedColor)
        }
        
        viewcontroller.categoriesAndSchedule = sections
        let navigationViewController = UINavigationController(rootViewController: viewcontroller)
        present(navigationViewController, animated: true)
    }
}
