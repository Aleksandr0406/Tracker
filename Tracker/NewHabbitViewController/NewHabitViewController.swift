//
//  NewHabbitViewController.swift
//  Tracker
//
//  Created by 1111 on 11.02.2025.
//

import UIKit

final class NewHabitViewController: UIViewController {
    var onAddHabitButtonTapped: ((String, String, [String]) -> ())?
    var categoriesAndSchedule: [String] = []
    
    private let emojiIndexSection = 0
    private let numberOfSections = 2
    private let enableNumberOfTypingLettersInTextField = 38
    private let numbersDaysInWeek = 7
    private var savedDays: [String] = []
    
    private let emojis =
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
    
    private var warningLabel: UILabel = UILabel()
    private var titleHabitTextField: UITextField = UITextField()
    private var cancelButton: UIButton = UIButton()
    private var addHabitButton: UIButton = UIButton()
    
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
        createAddHabitButton()
        createCollection()
        setConstraints()
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
        titleHabitTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 75))
        titleHabitTextField.leftViewMode = .always
        
        titleHabitTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleHabitTextField)
        
        titleHabitTextField.delegate = self
        titleHabitTextField.addTarget(self, action: #selector(didEditNameHabitTextField), for: .allEditingEvents)
    }
    
    @objc private func didEditNameHabitTextField() {
        checkAllFields()
        guard let numbersOfTypingLetters = titleHabitTextField.text?.count else { return }
        warningLabel.isHidden = !(numbersOfTypingLetters == enableNumberOfTypingLettersInTextField)
    }
    
    private func createWarningLabel() {
        warningLabel.text = "Ограничение 38 символов"
        warningLabel.font = .systemFont(ofSize: 17)
        warningLabel.textColor = .red
        warningLabel.textAlignment = .center
        warningLabel.isHidden = true
        
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(warningLabel)
    }
    
    private func createCategoryAndScheduleTable() {
        categoryAndScheduleTable.backgroundColor = UIColor(named: "E6E8EB")
        categoryAndScheduleTable.layer.cornerRadius = 16
        categoryAndScheduleTable.isScrollEnabled = false
        
        categoryAndScheduleTable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(categoryAndScheduleTable)
        
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
        
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
    }
    
    @objc private func didTapCancelButton() {
        UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true)
    }
    
    private func createAddHabitButton() {
        addHabitButton.backgroundColor = UIColor(named: "Add_Button")
        addHabitButton.layer.borderColor = UIColor(named: "Add_Button")?.cgColor
        addHabitButton.layer.borderWidth = 1
        addHabitButton.setTitle("Создать", for: .normal)
        addHabitButton.setTitleColor(UIColor.white, for: .normal)
        addHabitButton.layer.cornerRadius = 16
        
        addHabitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addHabitButton)
        
        addHabitButton.isEnabled = false
        addHabitButton.addTarget(self, action: #selector(didTapAddHabitButton), for: .touchUpInside)
    }
    
    @objc private func didTapAddHabitButton() {
        guard
            let habitName = titleHabitTextField.text,
            let categoryName = categoryAndScheduleTable.cellForRow(at: IndexPath(row: 0, section: 0))?.detailTextLabel?.text,
            let onAddHabitButtonTapped = onAddHabitButtonTapped
        else { return }
        onAddHabitButtonTapped(habitName, categoryName, savedDays)
        UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true)
    }
    
    private func createCollection() {
        collection.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collection)
        
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
    
    private func setConstraints() {
        let constraintValue: CGFloat = categoriesAndSchedule.count > 1 ? 150 : 75
        
        NSLayoutConstraint.activate([
            titleHabitTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleHabitTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleHabitTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleHabitTextField.heightAnchor.constraint(equalToConstant: 75),
            
            warningLabel.topAnchor.constraint(equalTo: titleHabitTextField.bottomAnchor, constant: 8),
            warningLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            warningLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -29),
            warningLabel.heightAnchor.constraint(equalToConstant: 22),
            
            categoryAndScheduleTable.topAnchor.constraint(equalTo: titleHabitTextField.bottomAnchor, constant: 62),
            categoryAndScheduleTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryAndScheduleTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            categoryAndScheduleTable.heightAnchor.constraint(equalToConstant: constraintValue),
            
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            cancelButton.widthAnchor.constraint(equalToConstant: 166),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            
            addHabitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addHabitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addHabitButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8),
            addHabitButton.heightAnchor.constraint(equalToConstant: 60),
            
            collection.topAnchor.constraint(equalTo: categoryAndScheduleTable.bottomAnchor, constant: 32),
            collection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collection.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -24)
        ])
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
                addHabitButton.backgroundColor = .black
                addHabitButton.isEnabled = true
            } else {
                addHabitButton.backgroundColor = UIColor(named: "Add_Button")
                addHabitButton.layer.borderColor = UIColor(named: "Add_Button")?.cgColor
                addHabitButton.layer.borderWidth = 1
                addHabitButton.isEnabled = false
            }
        } else {
            let checkTextField = titleHabitTextField.hasText
            guard let checkCategorySubtitle = categoryAndScheduleTable.cellForRow(at: IndexPath(row: 0, section: 0))?.detailTextLabel?.text?.isEmpty else { return }
            
            if checkTextField && !checkCategorySubtitle {
                addHabitButton.backgroundColor = .black
                addHabitButton.isEnabled = true
            } else {
                addHabitButton.backgroundColor = UIColor(named: "Add_Button")
                addHabitButton.layer.borderColor = UIColor(named: "Add_Button")?.cgColor
                addHabitButton.layer.borderWidth = 1
                addHabitButton.isEnabled = false
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
        CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 24, left: 18, bottom: 24, right: 19)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let headerView = NewHabitCollectionSupplementaryView()
        
        section == emojiIndexSection ? (headerView.titleLabel.text = "Emoji") : (headerView.titleLabel.text = "Цвет")
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: UIView.layoutFittingExpandedSize.height))
    }
}

extension NewHabitViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        numberOfSections
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        section == emojiIndexSection ? emojis.count : colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == emojiIndexSection {
            guard let emojiCell = collectionView.dequeueReusableCell(withReuseIdentifier: NewHabitEmojiCollectionCell.cellIdentifier, for: indexPath) as? NewHabitEmojiCollectionCell else {
                return UICollectionViewCell()
            }
            
            emojiCell.titleLabel.text = emojis[indexPath.row]
            return emojiCell
            
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
        
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? NewHabitCollectionSupplementaryView else { return UICollectionReusableView() }
        
        (indexPath.section == emojiIndexSection) ? (headerView.titleLabel.text = "Emoji") : (headerView.titleLabel.text = "Цвет")
        return headerView
    }
}

//MARK: TableView Protocols

extension NewHabitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.row == 0 {
            let viewcontroller = NewCategoryViewController()
            viewcontroller.onAddCategoryButtonTapped = { subtitleNameCategory in
                self.addSubtitleToCategory(subtitleNameCategory)
                self.categoryAndScheduleTable.reloadData()
                self.checkAllFields()
            }
            let navigationViewController = UINavigationController(rootViewController: viewcontroller)
            present(navigationViewController, animated: true)
        } else {
            let viewcontroller = NewScheduleViewController()
            viewcontroller.onDoneButtonTapped = { days in
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.bounds.height / CGFloat(categoriesAndSchedule.count)
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
}





