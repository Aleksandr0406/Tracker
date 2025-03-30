//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by 1111 on 15.02.2025.
//

import UIKit

final class NewCategoryViewController: UIViewController {
    var onAddCategoryButtonTapped: ((String) -> ())?
    
    private let localizableStrings: LocalizableStringsNewCategoryVC = LocalizableStringsNewCategoryVC()
    private let colorsForDarkLightTheme: ColorsForDarkLightTheme = ColorsForDarkLightTheme()
    private var viewModel: CategoriesViewModel = CategoriesViewModel()
    
    private var categoriesTable: UITableView = UITableView()
    private var backgroundImage: UIImageView = UIImageView()
    private var backgroundTextLabel: UILabel = UILabel()
    private var addCategoryButton: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = colorsForDarkLightTheme.whiteBlackDLT
        
        setBarItem()
        createBackgroundImage()
        createBackgroundTextLabel()
        createAddCategoryButton()
        createCategoriesTable()
        setConstraints()
        bind()
        
        checkPlaceholder()
    }
    
    private func checkPlaceholder() {
        let categoryNames = viewModel.loadSavedCategoriesNames()
        if !categoryNames.isEmpty {
            hidePlaceholder()
        }
    }
    
    private func bind() {
        viewModel.newCategoryNamesCreated = { [weak self] in
            self?.hidePlaceholder()
            self?.categoriesTable.reloadData()
        }
    }
    
    private func setBarItem() {
        navigationItem.title = localizableStrings.categoryTitle
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium), NSAttributedString.Key.foregroundColor: colorsForDarkLightTheme.blackWhiteDLT]
        navigationController?.navigationBar.titleTextAttributes = attributes
    }
    
    private func createBackgroundImage() {
        guard let backgroundImage = UIImage(named: "No_items") else { return }
        self.backgroundImage.image = backgroundImage
        
        self.backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self.backgroundImage)
    }
    
    private func createBackgroundTextLabel() {
        backgroundTextLabel.text = localizableStrings.placeholderTextPartOne + "\n" + localizableStrings.placeholderTextPartTwo
        backgroundTextLabel.numberOfLines = 2
        backgroundTextLabel.textColor = colorsForDarkLightTheme.blackWhiteDLT
        backgroundTextLabel.font = .systemFont(ofSize: 12, weight: UIFont.Weight.medium)
        backgroundTextLabel.textAlignment = .center
        
        backgroundTextLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundTextLabel)
    }
    
    private func createAddCategoryButton() {
        addCategoryButton.backgroundColor = colorsForDarkLightTheme.blackWhiteDLT
        addCategoryButton.setTitle(localizableStrings.addCategoryButtonTitle, for: .normal)
        addCategoryButton.titleLabel?.font = .systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        addCategoryButton.setTitleColor(colorsForDarkLightTheme.whiteBlackDLT, for: .normal)
        addCategoryButton.layer.cornerRadius = 16
        
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addCategoryButton)
        
        addCategoryButton.addTarget(self, action: #selector(didTapAddCategoryButton), for: .touchUpInside)
    }
    
    @objc private func didTapAddCategoryButton() {
        let viewcontroller = NewCategoryNameViewController()
        viewcontroller.onDoneButtonTapped = { [weak self] nameCategory in
            self?.viewModel.didCreateNewCategory(with: nameCategory)
        }
        let navigationViewController = UINavigationController(rootViewController: viewcontroller)
        present(navigationViewController, animated: true)
    }
    
    private func createCategoriesTable() {
        categoriesTable.backgroundColor = colorsForDarkLightTheme.whiteBlackDLT
        categoriesTable.layer.cornerRadius = 16
        categoriesTable.isScrollEnabled = false
        
        categoriesTable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(categoriesTable)
        
        categoriesTable.isHidden = true
        
        categoriesTable.dataSource = self
        categoriesTable.delegate = self
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
            backgroundTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func hidePlaceholder() {
        backgroundImage.isHidden = true
        backgroundTextLabel.isHidden = true
        categoriesTable.isHidden = false
        categoriesTable.isScrollEnabled = false
    }
}

extension NewCategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numbersOfRows = viewModel.loadSavedCategoriesNames().count
        return numbersOfRows
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let categoriesNames = viewModel.loadSavedCategoriesNames()
        let numbersOfRows = categoriesNames.count
        
        if indexPath.row == numbersOfRows - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            cell.layer.masksToBounds = true
        }
        
        cell.backgroundColor = colorsForDarkLightTheme.backgroundAndPlaceholderBackgroundOtherVC
        cell.textLabel?.text = categoriesNames[indexPath.row]
        cell.textLabel?.textColor = colorsForDarkLightTheme.blackWhiteDLT
        
        return cell
    }
}

extension NewCategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCell = tableView.cellForRow(at: indexPath) else { return }
        if selectedCell.accessoryType == .none {
            selectedCell.accessoryType = .checkmark
        }
        
        guard let subtitleNameCategory = selectedCell.textLabel?.text,
              let onAddCategoryButtonTapped = onAddCategoryButtonTapped else { return }
        onAddCategoryButtonTapped(subtitleNameCategory)
        
        dismiss(animated: true)
    }
}
