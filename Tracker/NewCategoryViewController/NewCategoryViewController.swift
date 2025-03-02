//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by 1111 on 15.02.2025.
//

import UIKit

final class NewCategoryViewController: UIViewController {
    var onAddCategoryButtonTapped: ((String) -> ())?
    
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
        setConstraints()
        
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
    
    private func createCategoriesTable() {
        categoriesTable.backgroundColor = UIColor.white
        categoriesTable.layer.cornerRadius = 16
        categoriesTable.isScrollEnabled = false
        
        categoriesTable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(categoriesTable)
        
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
    }
    
    private func createBackgroundTextLabel() {
        backgroundTextLabel.text = #"Привычки и события можно\#n объединить по смыслу"#
        backgroundTextLabel.numberOfLines = 2
        backgroundTextLabel.textColor = .black
        backgroundTextLabel.font = .systemFont(ofSize: 12)
        backgroundTextLabel.textAlignment = .center
        
        backgroundTextLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundTextLabel)
    }
    
    private func createAddCategoryButton() {
        addCategoryButton.backgroundColor = .black
        addCategoryButton.setTitle("Добавить категорию", for: .normal)
        addCategoryButton.setTitleColor(UIColor.white, for: .normal)
        addCategoryButton.layer.cornerRadius = 16
        
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addCategoryButton)
        
        addCategoryButton.addTarget(self, action: #selector(didTapAddCategoryButton), for: .touchUpInside)
    }
    
    @objc private func didTapAddCategoryButton() {
        let viewcontroller = NewCategoryNameViewController()
        viewcontroller.onDoneButtonTapped = { nameCategory in
            self.names.append(nameCategory)
            self.hidePlaceholder()
            self.categoriesTable.reloadData()
        }
        let navigationViewController = UINavigationController(rootViewController: viewcontroller)
        present(navigationViewController, animated: true)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            categoriesTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            categoriesTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoriesTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoriesTable.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor),
            
            backgroundImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 232),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 147),
            backgroundImage.widthAnchor.constraint(equalToConstant: 80),
            backgroundImage.heightAnchor.constraint(equalToConstant: 80),
            
            backgroundTextLabel.topAnchor.constraint(equalTo: backgroundImage.bottomAnchor, constant: 8),
            backgroundTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

extension NewCategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: IndexPath(row: index, section: 0))?.accessoryType = .none
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        index = indexPath.row
        guard let subtitleNameCategory = tableView.cellForRow(at: indexPath)?.textLabel?.text,
              let onAddCategoryButtonTapped = onAddCategoryButtonTapped else { return }
        onAddCategoryButtonTapped(subtitleNameCategory)
        
        dismiss(animated: true)
    }
}

extension NewCategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
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
}
