//
//  ViewController.swift
//  Tracker
//
//  Created by 1111 on 30.01.2025.
//

import UIKit


final class TrackersViewController: UIViewController {
    private var categories: [TrackerCategory] = []
    private var currentDate: Date = Date()
    
    private var completedTrackers: [TrackerRecord] = []
    
    private var searchTextField: UISearchTextField = UISearchTextField()
    private var titleLabel: UILabel = UILabel()
    private var backgroundImage: UIImageView = UIImageView()
    private var backgroundTextLabel: UILabel = UILabel()
    private var trackersCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.register(TrackersCollectionViewCell.self, forCellWithReuseIdentifier: "NewTracker")
        collection.register(TrackersCollectionSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setNaviBar()
        createTitleLabel()
        createSearchTextField()
        createBackgroundImage()
        createBackgroundTextLabel()
        createTrackersCollectionView()
    }
    
    private func setNaviBar() {
        let datePicker = setDatePicker()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        let leftButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
        navigationItem.setLeftBarButton(leftButton, animated: false)
    }
    
    @objc private func didTapAddButton() {
        let viewcontroller = NewTrackerViewController()
        viewcontroller.clousure = { savedHabitName, savedCategoryName in
            print("TrackerViewController", "Habit:", savedHabitName, ", ", "Category:", savedCategoryName)
            self.updateTrackers(savedHabitName, savedCategoryName)
        }
        let navigationViewController = UINavigationController(rootViewController: viewcontroller)
        present(navigationViewController, animated: true)
    }
    
    private func setDatePicker() -> UIDatePicker {
        let datePicker = UIDatePicker()
        let currentDate = Date()
        let calendar = Calendar.current
        let minDate = calendar.date(byAdding: .year, value: 0, to: currentDate)
        let maxDate = calendar.date(byAdding: .year, value: 100, to: currentDate)
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        return datePicker
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formattedDate = dateFormatter.string(from: currentDate)
        print("Выбранная дата: \(formattedDate)")
    }
    
    private func createTitleLabel() {
        titleLabel.text = "Трекеры"
        titleLabel.textColor = .black
        titleLabel.font = .boldSystemFont(ofSize: 34)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1).isActive = true
    }
    
    private func createBackgroundImage() {
        guard let backgroundImage = UIImage(named: "No_items") else { return }
        self.backgroundImage.image = backgroundImage
        
        self.backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self.backgroundImage)
        self.backgroundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.backgroundImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func createBackgroundTextLabel() {
        backgroundTextLabel.text = "Что будем отслеживать?"
        backgroundTextLabel.textColor = .black
        backgroundTextLabel.font = .systemFont(ofSize: 12, weight: UIFont.Weight(rawValue: 510))
        
        backgroundTextLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundTextLabel)
        backgroundTextLabel.topAnchor.constraint(equalTo: backgroundImage.bottomAnchor, constant: 8).isActive = true
        backgroundTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func createSearchTextField() {
        searchTextField.backgroundColor = .lightText
        searchTextField.textColor = .black
        searchTextField.font = UIFont.systemFont(ofSize: 17)
        searchTextField.placeholder = "Поиск"
        
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchTextField)
        searchTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7).isActive = true
        searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    private func createTrackersCollectionView() {
        trackersCollectionView.backgroundColor = .none
        
        trackersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackersCollectionView)
        
        trackersCollectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 24).isActive = true
        trackersCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        trackersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        trackersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        trackersCollectionView.dataSource = self
        trackersCollectionView.delegate = self
        
        trackersCollectionView.isHidden = true
    }
    
    private func updateTrackers(_ savedHabitName: String, _ savedCategoryName: String) {
        backgroundImage.isHidden = true
        backgroundTextLabel.isHidden = true
        trackersCollectionView.isHidden = false
        
        let newHabit = TrackerCategory(
            name: savedCategoryName,
            trackers:
                [
                    Tracker(
                        id: "",
                        name: savedHabitName,
                        color: .green,
                        emoji: "🙂",
                        shedule: ["Понедельник"])
                ]
        )
        
        categories.append(newHabit)
        
        trackersCollectionView.reloadData()
    }
}

extension TrackersViewController: UICollectionViewDelegate {}

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.first?.trackers?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewTracker", for: indexPath) as? TrackersCollectionViewCell else { return UICollectionViewCell() }
        
        cell.emojiLabel.text = "❤️"
        cell.habitNameLabel.text = categories.first?.trackers?.first?.name
        cell.dayLabel.text = "1 день"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = "header"
        case UICollectionView.elementKindSectionFooter:
            id = "footer"
        default:
            id = ""
        }
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as! TrackersCollectionSupplementaryView
        
        headerView.titleLabel.text = categories.first?.name
        return headerView
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 167, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(trackersCollectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: trackersCollectionView.frame.width,
                                                         height: UIView.layoutFittingExpandedSize.height))
    }
}
