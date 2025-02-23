//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by 1111 on 15.02.2025.
//

import Foundation
import UIKit

final class NewCategoryViewController: UIViewController {
    var clousure: ((String) -> ())!
    
    private var index: Int = 0
    private var names: [String] = []
    private var categoriesTable: UITableView = UITableView()
    private var backgroundImage: UIImageView = UIImageView()
    private var backgroundTextLabel: UILabel = UILabel()
    private var addCategoryButton: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setBarItem()
        createBackgroundImage()
        createBackgroundTextLabel()
        createAddCategoryButton()
        createCategoriesTable()
        
        if !names.isEmpty {
            hidePlaceholder()
        }
    }
    
    private func hidePlaceholder() {
        backgroundImage.isHidden = true
        backgroundTextLabel.isHidden = true
        categoriesTable.isHidden = false
        categoriesTable.isScrollEnabled = false
    }
    
    @objc func updateCategories() {
        hidePlaceholder()
        categoriesTable.reloadData()
    }
    
    private func createCategoriesTable() {
        categoriesTable.backgroundColor = UIColor.white
        categoriesTable.layer.cornerRadius = 16
        categoriesTable.isScrollEnabled = false
        
        categoriesTable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(categoriesTable)
        
        categoriesTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
        categoriesTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        categoriesTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        categoriesTable.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor).isActive = true
        
        categoriesTable.isHidden = true
        
        categoriesTable.dataSource = self
        categoriesTable.delegate = self
    }
    
    private func setBarItem() {
        navigationItem.title = "Категория"
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        navigationController?.navigationBar.titleTextAttributes = attributes
    }
    
    private func createBackgroundImage() {
        guard let backgroundImage = UIImage(named: "No_items") else { return }
        self.backgroundImage.image = backgroundImage
        
        self.backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self.backgroundImage)
        
        self.backgroundImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 232).isActive = true
        self.backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 147).isActive = true
        self.backgroundImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        self.backgroundImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    private func createBackgroundTextLabel() {
        backgroundTextLabel.text = #"Привычки и события можно\#n объединить по смыслу"#
        backgroundTextLabel.numberOfLines = 2
        backgroundTextLabel.textColor = .black
        backgroundTextLabel.font = .systemFont(ofSize: 12, weight: UIFont.Weight(rawValue: 510))
        backgroundTextLabel.textAlignment = .center
        
        backgroundTextLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundTextLabel)
        backgroundTextLabel.topAnchor.constraint(equalTo: backgroundImage.bottomAnchor, constant: 8).isActive = true
        backgroundTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func createAddCategoryButton() {
        addCategoryButton.backgroundColor = .black
        addCategoryButton.setTitle("Добавить категорию", for: .normal)
        addCategoryButton.setTitleColor(UIColor.white, for: .normal)
        addCategoryButton.layer.cornerRadius = 16
        
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addCategoryButton)
        
        addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        addCategoryButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        addCategoryButton.addTarget(self, action: #selector(didTapAddCategoryButton), for: .touchUpInside)
    }
    
    @objc private func didTapAddCategoryButton() {
        let viewcontroller = NewCategoryNameViewController()
        viewcontroller.clousure = { nameCategory in
            self.names.append(nameCategory)
            self.hidePlaceholder()
            self.categoriesTable.reloadData()
        }
        let navigationViewController = UINavigationController(rootViewController: viewcontroller)
        present(navigationViewController, animated: true)
    }
}

extension NewCategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "NewCategory")
        
        if indexPath.row == index {
            cell.backgroundColor = UIColor(named: "E6E8EB")
            cell.textLabel?.text = names[index]
            cell.accessoryType = .checkmark
        } else {
            cell.backgroundColor = UIColor(named: "E6E8EB")
            cell.textLabel?.text = names[indexPath.row]
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: IndexPath(row: index, section: 0))?.accessoryType = .none
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        index = indexPath.row
        guard let subtitleNameCategory = tableView.cellForRow(at: indexPath)?.textLabel?.text else { return }
        clousure(subtitleNameCategory)
        
        dismiss(animated: true)
    }
}
