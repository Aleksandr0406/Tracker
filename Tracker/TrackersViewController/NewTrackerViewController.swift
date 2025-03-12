//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by 1111 on 11.02.2025.
//

import UIKit

final class NewTrackerViewController: UIViewController {
    var onAddHabitButtonTapped: (((String, String, [String], String, UIColor) -> ()))?
    
    private let addNewTrackerButton: UIButton = UIButton()
    private let addNewNotRegularEventButton: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setBarItem()
        createAddNewTrackerButton()
        createAddNewNotRegularEventButton()
        setConstraints()
    }
    
    private func setBarItem() {
        navigationItem.title = "Создание трекера"
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        navigationController?.navigationBar.titleTextAttributes = attributes
    }
    
    private func createAddNewTrackerButton() {
        addNewTrackerButton.layer.cornerRadius = 16
        addNewTrackerButton.backgroundColor = .black
        addNewTrackerButton.setTitle("Привычка", for: .normal)
        addNewTrackerButton.setTitleColor(.white, for: .normal)
        addNewTrackerButton.titleLabel?.textAlignment = .center
        addNewTrackerButton.titleLabel?.font = .systemFont(ofSize: 16)
        
        addNewTrackerButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addNewTrackerButton)
        
        addNewTrackerButton.addTarget(self, action: #selector(didTapAddNewTrackerButton), for: .touchUpInside)
    }
    
    @objc private func didTapAddNewTrackerButton() {
        let sections = ["Категория", "Расписание"]
        presentHabitOrNotRegularEvent(sections)
    }
    
    private func createAddNewNotRegularEventButton() {
        addNewNotRegularEventButton.layer.cornerRadius = 16
        addNewNotRegularEventButton.backgroundColor = .black
        addNewNotRegularEventButton.setTitle("Нерегулярное событие", for: .normal)
        addNewNotRegularEventButton.setTitleColor(.white, for: .normal)
        addNewNotRegularEventButton.titleLabel?.textAlignment = .center
        addNewNotRegularEventButton.titleLabel?.font = .systemFont(ofSize: 16)
        
        addNewNotRegularEventButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addNewNotRegularEventButton)
        
        addNewNotRegularEventButton.addTarget(self, action: #selector(didTapAddNewNotRegularEventButton), for: .touchUpInside)
    }
    
    @objc private func didTapAddNewNotRegularEventButton() {
        let sections = ["Категория"]
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
        let viewcontroller = NewHabitViewController()
        viewcontroller.onAddHabitButtonTapped = { savedHabitName, savedCategoryName, savedDays, savedEmoji, savedColor in
            guard let onAddHabitButtonTapped = self.onAddHabitButtonTapped else { return }
            onAddHabitButtonTapped(savedHabitName, savedCategoryName, savedDays, savedEmoji, savedColor)
        }
        
        viewcontroller.categoriesAndSchedule = sections
        let navigationViewController = UINavigationController(rootViewController: viewcontroller)
        present(navigationViewController, animated: true)
    }
}
