//
//  NewHabbitViewController.swift
//  Tracker
//
//  Created by 1111 on 11.02.2025.
//

import Foundation
import UIKit

final class NewHabitViewController: UIViewController {
    var clousure: ((String, String, [String]) -> ())!
    var categoriesAndSchedule: [String] = []
    
    private let numberOfSections = 2
    
    private let emojies =
    [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱", "😊", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    
    private let colors =
    [
        UIColor(named: "FD4C49")
    ]
    
    private let shortNamesDaysOfWeek: [String : String] =
    [
        "Понедельник" : "Пнд",
        "Вторник" : "Вт",
        "Среда" : "Ср",
        "Четверг" : "Чт",
        "Пятница" : "Пт",
        "Суббота" : "Сб",
        "Воскресенье" : "Вс"
    ]
    
    private var savedDays: [String] = []
    
    private let numbersDaysInWeek = 7
    
    private var warningLabel: UILabel = UILabel()
    private var titleHabitTextField: UITextField = UITextField()
    private var cancelButton: UIButton = UIButton()
    private var addHabbitButton: UIButton = UIButton()
    
    private var categoryAndScheduleTable: UITableView = {
        let tableView = UITableView()
        tableView.register(NewHabitTableViewCell.self, forCellReuseIdentifier: NewHabitTableViewCell.cellIdentifier)
        return tableView
    }()
    
    private var collection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.register(NewHabitEmojiCollectionCell.self, forCellWithReuseIdentifier: NewHabitEmojiCollectionCell.cellIdentifier)
        collection.register(NewHabitColorCollectionCell.self, forCellWithReuseIdentifier: NewHabitColorCollectionCell.cellIdentifier)
        collection.register(NewHabitCollectionSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NewHabitCollectionSupplementaryView.headerIdentifier)
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setBarItem()
        createTitleHabitTextField()
        createWarningLabel()
        createCategoryAndScheduleTable()
        createCancelButton()
        createAddHabbitButton()
        createCollection()
    }
    
    private func setBarItem() {
        if categoriesAndSchedule.count > 1 {
            navigationItem.title = "Новая привычка"
        } else {
            navigationItem.title = "Новое нерегулярное событие"
            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
            navigationController?.navigationBar.titleTextAttributes = attributes
        }
    }
    
    private func createTitleHabitTextField() {
        titleHabitTextField.placeholder = "Введите название трекера"
        titleHabitTextField.backgroundColor = UIColor(named: "E6E8EB")
        titleHabitTextField.layer.cornerRadius = 16
        titleHabitTextField.clearButtonMode = .always
        
        titleHabitTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleHabitTextField)
        
        titleHabitTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
        titleHabitTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        titleHabitTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        titleHabitTextField.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        titleHabitTextField.delegate = self
        titleHabitTextField.addTarget(self, action: #selector(didEditNameHabitTextField), for: .allEditingEvents)
    }
    
    @objc private func didEditNameHabitTextField() {
        checkAllFields()
        
        guard let numbersOfLetters = titleHabitTextField.text?.count else { return }
        
        if numbersOfLetters == 38 {
            warningLabel.isHidden = false
        } else {
            warningLabel.isHidden = true
        }
    }
    
    private func createWarningLabel() {
        warningLabel.text = "Ограничение 38 символов"
        warningLabel.font = .systemFont(ofSize: 17)
        warningLabel.textColor = .red
        warningLabel.textAlignment = .center
        warningLabel.isHidden = true
        
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(warningLabel)
        
        warningLabel.topAnchor.constraint(equalTo: titleHabitTextField.bottomAnchor, constant: 8).isActive = true
        warningLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28).isActive = true
        warningLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -29).isActive = true
        warningLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }
    
    private func createCategoryAndScheduleTable() {
        categoryAndScheduleTable.backgroundColor = UIColor(named: "E6E8EB")
        categoryAndScheduleTable.layer.cornerRadius = 16
        categoryAndScheduleTable.isScrollEnabled = false
        
        categoryAndScheduleTable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(categoryAndScheduleTable)
        
        categoryAndScheduleTable.topAnchor.constraint(equalTo: titleHabitTextField.bottomAnchor, constant: 24).isActive = true
        categoryAndScheduleTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        categoryAndScheduleTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        if categoriesAndSchedule.count > 1 {
            categoryAndScheduleTable.heightAnchor.constraint(equalToConstant: 150).isActive = true
        } else {
            categoryAndScheduleTable.heightAnchor.constraint(equalToConstant: 75).isActive = true
        }
        
        categoryAndScheduleTable.dataSource = self
        categoryAndScheduleTable.delegate = self
    }
    
    private func createCancelButton() {
        cancelButton.backgroundColor = .white
        cancelButton.layer.borderColor = UIColor(named: "Cancel_Button")?.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(UIColor(named: "Cancel_Button"), for: .normal)
        cancelButton.layer.cornerRadius = 16
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cancelButton)
        
        cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 166).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
    }
    
    @objc private func didTapCancelButton() {
        UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true)
    }
    
    private func createAddHabbitButton() {
        addHabbitButton.backgroundColor = UIColor(named: "Add_Button")
        addHabbitButton.layer.borderColor = UIColor(named: "Add_Button")?.cgColor
        addHabbitButton.layer.borderWidth = 1
        addHabbitButton.setTitle("Создать", for: .normal)
        addHabbitButton.setTitleColor(UIColor.white, for: .normal)
        addHabbitButton.layer.cornerRadius = 16
        
        addHabbitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addHabbitButton)
        
        addHabbitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        addHabbitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        addHabbitButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8).isActive = true
        addHabbitButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        addHabbitButton.isEnabled = false
        addHabbitButton.addTarget(self, action: #selector(didTapAddHabbitButton), for: .touchUpInside)
    }
    
    @objc private func didTapAddHabbitButton() {
        guard
            let habitName = titleHabitTextField.text,
            let categoryName = categoryAndScheduleTable.cellForRow(at: IndexPath(row: 0, section: 0))?.detailTextLabel?.text
        else { return }
        clousure(habitName, categoryName, savedDays)
        UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true)
    }
    
    private func createCollection() {
        collection.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collection)
        
        collection.topAnchor.constraint(equalTo: categoryAndScheduleTable.bottomAnchor, constant: 32).isActive = true
        collection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        collection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        collection.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -24).isActive = true
        
        collection.dataSource = self
        collection.delegate = self
    }
    
    private func addSubtitleToCategory(_ subtitleNameCategory: String) {
        guard let cell = categoryAndScheduleTable.cellForRow(at: IndexPath(row: 0, section: 0)) else { return }
        cell.detailTextLabel?.text = subtitleNameCategory
        cell.detailTextLabel?.textColor = UIColor(named: "Add_Button")
        cell.detailTextLabel?.font = .systemFont(ofSize: 17)
    }
    
    private func addSubtitleToSchedule(_ subtitleNameSchedule: [String]) {
        guard let cell = categoryAndScheduleTable.cellForRow(at: IndexPath(row: 1, section: 0)) else { return }
        
        let savedShortNameDays = setShortNamesToDaysOfWeek(subtitleNameSchedule)
        cell.detailTextLabel?.text = savedShortNameDays
        cell.detailTextLabel?.textColor = UIColor(named: "Add_Button")
        cell.detailTextLabel?.font = .systemFont(ofSize: 17)
    }
    
    private func setShortNamesToDaysOfWeek(_ savedLongNamesOfWeek: [String]) -> String {
        var savedDaysNames = ""
        var day = ""
        var shortNameDay = ""
        
        for dayNumber in 0..<savedLongNamesOfWeek.count {
            if savedLongNamesOfWeek.count == numbersDaysInWeek {
                savedDaysNames = "Каждый день"
            } else {
                if dayNumber == savedLongNamesOfWeek.count - 1{
                    day = savedLongNamesOfWeek[dayNumber]
                    shortNameDay = shortNamesDaysOfWeek[day]!
                    savedDaysNames += shortNameDay
                } else {
                    day = savedLongNamesOfWeek[dayNumber]
                    shortNameDay = shortNamesDaysOfWeek[day]!
                    savedDaysNames += shortNameDay + ", "
                }
            }
        }
        return savedDaysNames
    }
    
    private func checkAllFields() {
        if categoriesAndSchedule.count > 1 {
            let checkTextField = titleHabitTextField.hasText
            guard let checkCategorySubtitle = categoryAndScheduleTable.cellForRow(at: IndexPath(row: 0, section: 0))?.detailTextLabel?.text?.isEmpty,
                  let checkScheduleSubtitle = categoryAndScheduleTable.cellForRow(at: IndexPath(row: 1, section: 0))?.detailTextLabel?.text?.isEmpty else { return }
            
            if checkTextField && !checkCategorySubtitle && !checkScheduleSubtitle {
                addHabbitButton.backgroundColor = .black
                addHabbitButton.isEnabled = true
            } else {
                addHabbitButton.backgroundColor = UIColor(named: "Add_Button")
                addHabbitButton.layer.borderColor = UIColor(named: "Add_Button")?.cgColor
                addHabbitButton.layer.borderWidth = 1
                addHabbitButton.isEnabled = false
            }
        } else {
            let checkTextField = titleHabitTextField.hasText
            guard let checkCategorySubtitle = categoryAndScheduleTable.cellForRow(at: IndexPath(row: 0, section: 0))?.detailTextLabel?.text?.isEmpty else { return }
            
            if checkTextField && !checkCategorySubtitle {
                addHabbitButton.backgroundColor = .black
                addHabbitButton.isEnabled = true
            } else {
                addHabbitButton.backgroundColor = UIColor(named: "Add_Button")
                addHabbitButton.layer.borderColor = UIColor(named: "Add_Button")?.cgColor
                addHabbitButton.layer.borderWidth = 1
                addHabbitButton.isEnabled = false
            }
        }
    }
}

//MARK: TextField Protocols

extension NewHabitViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 38
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        
        return newString.count <= maxLength
    }
}

//MARK: CollectionView Protocols
extension NewHabitViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 18, bottom: 24, right: 19)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collection, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collection.frame.width,
                                                         height: UIView.layoutFittingExpandedSize.height))
    }
}

extension NewHabitViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (section == 0) ? emojies.count : colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewHabitEmojiCollectionCell.cellIdentifier, for: indexPath) as? NewHabitEmojiCollectionCell else {
                return UICollectionViewCell()
            }
            cell.titleLabel.text = emojies[indexPath.row]
            return cell
            
        } else {
            guard let colorCell = collectionView.dequeueReusableCell(withReuseIdentifier: NewHabitColorCollectionCell.cellIdentifier, for: indexPath) as? NewHabitColorCollectionCell else {
                return UICollectionViewCell()
            }
            
            colorCell.layer.cornerRadius = 8
            colorCell.backgroundColor = colors[indexPath.row]
            return colorCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = NewHabitCollectionSupplementaryView.headerIdentifier
        case UICollectionView.elementKindSectionFooter:
            id = "footer"
        default:
            id = ""
        }
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as! NewHabitCollectionSupplementaryView
        
        (indexPath.section == 0) ? (headerView.titleLabel.text = "Emoji") : (headerView.titleLabel.text = "Цвет")
        return headerView
    }
}

//MARK: TableView Protocols
extension NewHabitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.row == 0 {
            let viewcontroller = NewCategoryViewController()
            viewcontroller.clousure = { subtitleNameCategory in
                self.addSubtitleToCategory(subtitleNameCategory)
                self.categoryAndScheduleTable.reloadData()
                self.checkAllFields()
            }
            let navigationViewController = UINavigationController(rootViewController: viewcontroller)
            present(navigationViewController, animated: true)
        } else {
            let viewcontroller = NewScheduleViewController()
            viewcontroller.clousure = { days in
                self.addSubtitleToSchedule(days)
                self.categoryAndScheduleTable.reloadData()
                self.checkAllFields()
                self.savedDays = days
            }
            let navigationViewController = UINavigationController(rootViewController: viewcontroller)
            present(navigationViewController, animated: true)
        }
        return indexPath
    }
}

extension NewHabitViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesAndSchedule.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->  UITableViewCell {
        let cell: UITableViewCell
        
        if let newHabitCell = tableView.dequeueReusableCell(withIdentifier: NewHabitTableViewCell.cellIdentifier, for: indexPath) as? NewHabitTableViewCell {
            cell = newHabitCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: NewHabitTableViewCell.cellIdentifier)
        }
        
        cell.backgroundColor = UIColor(named: "E6E8EB")
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = categoriesAndSchedule[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / CGFloat(categoriesAndSchedule.count)
    }
}





