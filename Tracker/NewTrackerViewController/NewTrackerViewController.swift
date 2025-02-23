//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by 1111 on 11.02.2025.
//

import Foundation
import UIKit

final class NewTrackerViewController: UIViewController {
    var clousure: (((String, String) -> ()))!
    
    private let addNewTrackerButton: UIButton = UIButton()
    private let addNewNotRegularTrackerButton: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setBarItem()
        createAddNewTrackerButton()
        createAddNewNotRegularTrackerButton()
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
        
        addNewTrackerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -357).isActive = true
        addNewTrackerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        addNewTrackerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        addNewTrackerButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        addNewTrackerButton.addTarget(self, action: #selector(didTapAddNewTrackerButton), for: .touchUpInside)
    }
    
    private func createAddNewNotRegularTrackerButton() {
        addNewNotRegularTrackerButton.layer.cornerRadius = 16
        addNewNotRegularTrackerButton.backgroundColor = .black
        addNewNotRegularTrackerButton.setTitle("Нерегулярное событие", for: .normal)
        addNewNotRegularTrackerButton.setTitleColor(.white, for: .normal)
        addNewNotRegularTrackerButton.titleLabel?.textAlignment = .center
        addNewNotRegularTrackerButton.titleLabel?.font = .systemFont(ofSize: 16)
        
        addNewNotRegularTrackerButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addNewNotRegularTrackerButton)
        
        addNewNotRegularTrackerButton.topAnchor.constraint(equalTo: addNewTrackerButton.bottomAnchor, constant: 16).isActive = true
        addNewNotRegularTrackerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        addNewNotRegularTrackerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        addNewNotRegularTrackerButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        addNewNotRegularTrackerButton.addTarget(self, action: #selector(didTapAddNewNotRegularTrackerButton), for: .touchUpInside)
    }
    
    @objc private func didTapAddNewTrackerButton() {
        let viewcontroller = NewHabitViewController()
        viewcontroller.clousure = { savedHabitName, savedCategoryName in
            self.clousure(savedHabitName, savedCategoryName)
            print("NewTrackerViewController", "Habit:", savedHabitName, ", ", "Category:", savedCategoryName)
        }
        viewcontroller.categoriesAndSchedule = ["Категория", "Расписание"]
        let navigationViewController = UINavigationController(rootViewController: viewcontroller)
        present(navigationViewController, animated: true)
    }
    
    @objc private func didTapAddNewNotRegularTrackerButton() {
        let viewcontroller = NewHabitViewController()
        viewcontroller.clousure = { savedHabitName, savedCategoryName in
            self.clousure(savedHabitName, savedCategoryName)
            print("NewTrackerViewController", "Habit:", savedHabitName, ", ", "Category:", savedCategoryName)
        }
        viewcontroller.categoriesAndSchedule = ["Категория"]
        let navigationViewController = UINavigationController(rootViewController: viewcontroller)
        present(navigationViewController, animated: true)
    }
    
    private func presentHabitOrNotRegularTracker() {
        let viewcontroller = NewHabitViewController()
        viewcontroller.clousure = { savedHabitName, savedCategoryName in
            self.clousure(savedHabitName, savedCategoryName)
            print("NewTrackerViewController", "Habit:", savedHabitName, ", ", "Category:", savedCategoryName)
        }
        let navigationViewController = UINavigationController(rootViewController: viewcontroller)
        present(navigationViewController, animated: true)
    }
}
