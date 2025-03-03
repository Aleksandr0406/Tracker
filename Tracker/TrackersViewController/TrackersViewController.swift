//
//  ViewController.swift
//  Tracker
//
//  Created by 1111 on 30.01.2025.
//

import UIKit

final class TrackersViewController: UIViewController {
    private var currentDate: Date = Date()
    private var categories: [TrackerCategory] = []
    private var visibleCategories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var savedDayNumberOfWeekend: [Int] = []
    
    private var searchTextField: UISearchTextField = UISearchTextField()
    private var titleLabel: UILabel = UILabel()
    private var backgroundImage: UIImageView = UIImageView()
    private var backgroundTextLabel: UILabel = UILabel()
    
    private var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        let currentDate = Date()
        let calendar = Calendar.current
        let minDate = calendar.date(byAdding: .year, value: 0, to: currentDate)
        let maxDate = calendar.date(byAdding: .year, value: 100, to: currentDate)
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        
        return datePicker
    }()
    
    private var trackersCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.register(TrackersCollectionCell.self, forCellWithReuseIdentifier: TrackersCollectionCell.cellIdentifier)
        collection.register(TrackersCollectionSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackersCollectionSupplementaryView.headerIdentifier)
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
        setConstraints()
    }
    
    private func setNaviBar() {
        datePicker.addTarget(self, action: #selector(didChangeDate), for: .valueChanged)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        let leftButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
        navigationItem.setLeftBarButton(leftButton, animated: false)
    }
    
    @objc private func didChangeDate() {
        let calendar = Calendar.current
        let filterWeekday = calendar.component(.weekday, from: datePicker.date)
        
        visibleCategories = categories.compactMap { category in
            let trackersWithSchedule = category.trackers.filter { tracker in
                tracker.schedule.contains { weekDay in
                    weekDay == filterWeekday
                }
            }
            
            let trackersWithNoSchedule = category.trackers.filter { tracker in
                tracker.schedule.isEmpty
            }
            
            let trackers = trackersWithSchedule + trackersWithNoSchedule
            
            if trackers.isEmpty {
                return nil
            }
            
            return TrackerCategory(name: category.name, trackers: trackers)
        }
        
        let isEmpty = visibleCategories.allSatisfy { $0.trackers.isEmpty }
        trackersCollectionView.isHidden = isEmpty
        backgroundImage.isHidden = !isEmpty
        backgroundTextLabel.isHidden = !isEmpty
        
        trackersCollectionView.reloadData()
    }
    
    @objc private func didTapAddButton() {
        let viewcontroller = NewTrackerViewController()
        viewcontroller.onAddHabitButtonTapped = { savedHabitName, savedCategoryName, savedDays in
            self.updateTrackers(savedHabitName, savedCategoryName, savedDays)
        }
        let navigationViewController = UINavigationController(rootViewController: viewcontroller)
        present(navigationViewController, animated: true)
    }
    
    //MARK: Creating elements on screen
    
    private func createTitleLabel() {
        titleLabel.text = "Трекеры"
        titleLabel.textColor = .black
        titleLabel.font = .boldSystemFont(ofSize: 34)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
    }
    
    private func createBackgroundImage() {
        backgroundImage.image = UIImage(named: "No_items")
        
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImage)
    }
    
    private func createBackgroundTextLabel() {
        backgroundTextLabel.text = "Что будем отслеживать?"
        backgroundTextLabel.textColor = .black
        backgroundTextLabel.font = .systemFont(ofSize: 12)
        
        backgroundTextLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundTextLabel)
    }
    
    private func createSearchTextField() {
        searchTextField.backgroundColor = .lightText
        searchTextField.textColor = .black
        searchTextField.font = UIFont.systemFont(ofSize: 17)
        searchTextField.placeholder = "Поиск"
        
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchTextField)
    }
    
    private func createTrackersCollectionView() {
        trackersCollectionView.backgroundColor = .none
        
        trackersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackersCollectionView)
        
        trackersCollectionView.dataSource = self
        trackersCollectionView.delegate = self
        
        trackersCollectionView.isHidden = true
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            
            backgroundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            backgroundTextLabel.topAnchor.constraint(equalTo: backgroundImage.bottomAnchor, constant: 8),
            backgroundTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            searchTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchTextField.heightAnchor.constraint(equalToConstant: 36),
            
            trackersCollectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 24),
            trackersCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
    //MARK: Helpers
    
    private func updateTrackers(_ savedHabitName: String, _ savedCategoryName: String, _ savedDays: [String]) {
        backgroundImage.isHidden = true
        backgroundTextLabel.isHidden = true
        trackersCollectionView.isHidden = false
        
        convertSavedDaysToNumbersOfWeekend(savedDays)
        
        if !categories.isEmpty {
            for categoryIndex in 0..<categories.count {
                var trackers: [Tracker] = categories[categoryIndex].trackers
                
                if savedCategoryName == categories[categoryIndex].name {
                    let newTrackerExistCategory = Tracker(
                        name: savedHabitName,
                        color: .green,
                        emoji: "🙂",
                        schedule: savedDayNumberOfWeekend)
                    
                    trackers.append(newTrackerExistCategory)
                    categories[categoryIndex] = TrackerCategory(name: categories[categoryIndex].name, trackers: trackers)
                    break
                }
                
                if (categoryIndex == categories.count - 1) && (savedCategoryName != categories[categoryIndex].name) {
                    let newTrackerNewCategory = TrackerCategory(
                        name: savedCategoryName,
                        trackers:
                            [
                                Tracker(
                                    name: savedHabitName,
                                    color: .green,
                                    emoji: "🙂",
                                    schedule: savedDayNumberOfWeekend)
                            ]
                    )
                    
                    categories.append(newTrackerNewCategory)
                }
            }
        } else {
            let newTrackerNewCategory = TrackerCategory(
                name: savedCategoryName,
                trackers:
                    [
                        Tracker(
                            name: savedHabitName,
                            color: .green,
                            emoji: "🙂",
                            schedule: savedDayNumberOfWeekend)
                    ]
            )
            
            categories.append(newTrackerNewCategory)
        }
        
        trackersCollectionView.reloadData()
        didChangeDate()
    }
    
    private func convertSavedDaysToNumbersOfWeekend(_ savedDays: [String]) {
        let dayNumbers: [String: Int] = [
            "Понедельник": 2, "Вторник": 3, "Среда": 4,
            "Четверг": 5, "Пятница": 6, "Суббота": 7, "Воскресенье": 1
        ]
        
        savedDayNumberOfWeekend = savedDays.compactMap { dayNumbers[$0] }
    }
}

//MARK: CollectionView Protocols

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackersCollectionCell.cellIdentifier, for: indexPath) as? TrackersCollectionCell else { return UICollectionViewCell() }
        
        let cellData = visibleCategories
        let tracker = cellData[indexPath.section].trackers[indexPath.row]
        
        cell.delegate = self
        
        let isCompletedToday = isTrackerCompletedToday(id: tracker.id)
        let completedDays = completedTrackers.filter {
            $0.id == tracker.id
        }.count
        
        cell.configure(with: tracker, isCompletedToday: isCompletedToday, indexPath: indexPath, completedDays: completedDays)
        
        return cell
    }
    
    private func isTrackerCompletedToday(id: UUID) -> Bool {
        completedTrackers.contains { trackerRecord in
            let sameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
            return trackerRecord.id == id && sameDay
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = TrackersCollectionSupplementaryView.headerIdentifier
        case UICollectionView.elementKindSectionFooter:
            id = "footer"
        default:
            id = ""
        }
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as! TrackersCollectionSupplementaryView
        
        headerView.titleLabel.text = visibleCategories[indexPath.section].name
        return headerView
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 167, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let headerView = TrackersCollectionSupplementaryView()
        headerView.titleLabel.text = visibleCategories[section].name
        
        return headerView.systemLayoutSizeFitting(CGSize(width: trackersCollectionView.frame.width,
                                                         height: UIView.layoutFittingExpandedSize.height))
    }
}

//MARK: Delegate Protocol

extension TrackersViewController: TrackersCollectionCellDelegate {
    func completeTracker(id: UUID, at indexPath: IndexPath) {
        let sameDay = Calendar.current.isDate(currentDate, inSameDayAs: datePicker.date)
        if sameDay {
            let trackerRecord = TrackerRecord(id: id, date: datePicker.date)
            completedTrackers.append(trackerRecord)
            
            trackersCollectionView.reloadItems(at: [indexPath])
        } else {
            print("Cant add day")
        }
    }
    
    func uncompleteTracker(id: UUID, at indexPath: IndexPath) {
        let sameDay = Calendar.current.isDate(currentDate, inSameDayAs: datePicker.date)
        if sameDay {
            completedTrackers.removeAll { trackerRecord in
                let sameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
                return trackerRecord.id == id && sameDay
            }
            
            trackersCollectionView.reloadItems(at: [indexPath])
        } else {
            print("Cant add day")
        }
    }
}
