//
//  NewCategoryNameViewController.swift
//  Tracker
//
//  Created by 1111 on 15.02.2025.
//

import Foundation
import UIKit

final class NewCategoryNameViewController: UIViewController, UITextFieldDelegate {
    var clousure: ((String) -> ())!
    
    private var doneButton: UIButton = UIButton()
    private var titleCategoryTextField: UITextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setBarItem()
        createTitleCategoryTextField()
        createDoneButton()
    }
    
    private func setBarItem() {
        navigationItem.title = "Новая категория"
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        navigationController?.navigationBar.titleTextAttributes = attributes
    }
    
    private func createTitleCategoryTextField() {
        titleCategoryTextField.placeholder = "Введите название категории"
        titleCategoryTextField.backgroundColor = UIColor(named: "E6E8EB")
        titleCategoryTextField.layer.cornerRadius = 16
        
        titleCategoryTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleCategoryTextField)
        
        titleCategoryTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
        titleCategoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        titleCategoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        titleCategoryTextField.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        titleCategoryTextField.delegate = self
        titleCategoryTextField.addTarget(self, action: #selector(didEditCategoryTextField), for: .editingChanged)
    }
    
    @objc private func didEditCategoryTextField() {
        if titleCategoryTextField.hasText {
            doneButton.backgroundColor = .black
            doneButton.isEnabled = true
        } else {
            doneButton.backgroundColor = UIColor(named: "Add_Button")
            doneButton.isEnabled = false
        }
    }
    
    private func createDoneButton() {
        doneButton.backgroundColor = UIColor(named: "Add_Button")
        doneButton.setTitle("Готово", for: .normal)
        doneButton.setTitleColor(UIColor.white, for: .normal)
        doneButton.layer.cornerRadius = 16
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(doneButton)
        
        doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        doneButton.isEnabled = false
    }
    
    @objc private func didTapDoneButton() {
        guard let nameCategory = titleCategoryTextField.text else { return }
        clousure(nameCategory)
        
        dismiss(animated: true)
        return
    }
}
