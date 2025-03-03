//
//  NewCategoryNameViewController.swift
//  Tracker
//
//  Created by 1111 on 15.02.2025.
//

import UIKit

final class NewCategoryNameViewController: UIViewController, UITextFieldDelegate {
    var onDoneButtonTapped: ((String) -> ())?
    
    private var doneButton: UIButton = UIButton()
    private var titleCategoryTextField: UITextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setBarItem()
        createTitleCategoryTextField()
        createDoneButton()
        setConstraints()
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
        titleCategoryTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 75))
        titleCategoryTextField.leftViewMode = .always
        
        titleCategoryTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleCategoryTextField)
        
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
        
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        doneButton.isEnabled = false
    }
    
    @objc private func didTapDoneButton() {
        guard let nameCategory = titleCategoryTextField.text,
              let onDoneButtonTapped = onDoneButtonTapped else { return }
        
        onDoneButtonTapped(nameCategory)
        
        dismiss(animated: true)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleCategoryTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleCategoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleCategoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleCategoryTextField.heightAnchor.constraint(equalToConstant: 75),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
