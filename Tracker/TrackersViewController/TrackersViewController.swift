//
//  ViewController.swift
//  Tracker
//
//  Created by 1111 on 30.01.2025.
//

import UIKit

final class TrackersViewController: UIViewController {
    private let convertScheduleDays: ConvertScheduleDays = ConvertScheduleDays()
    private let localizableStrings: LocalizableStringsTrackersVC = LocalizableStringsTrackersVC()
    private let colorsForDarkLightTheme: ColorsForDarkLightTheme = ColorsForDarkLightTheme()
    private let uiColorMarshalling: UIColorMarshalling = UIColorMarshalling()
    private var trackerRecordStore: TrackerRecordStore = TrackerRecordStore()
    private var trackerCategoryStore: TrackerCategoryStore = TrackerCategoryStore()
    private var dataProvider: DataProvider = DataProvider()
    private var currentDate: Date = Date()
    private var categories: [TrackerCategory] = []
    private var visibleCategories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var savedCheckedFilterCategory: String?
    
    private var searchTextField: UISearchTextField = UISearchTextField()
    private var titleLabel: UILabel = UILabel()
    private var backgroundImage: UIImageView = UIImageView()
    private var backgroundTextLabel: UILabel = UILabel()
    private var filterButton: UIButton = UIButton()
    
    private var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        let currentDate = Date()
        let calendar = Calendar.current
        
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
        self.view.backgroundColor = colorsForDarkLightTheme.whiteBlackDLT
        
        setNaviBar()
        createTitleLabel()
        createSearchTextField()
        createBackgroundImage()
        createBackgroundTextLabel()
        createTrackersCollectionView()
        createFilterButton()
        setConstraints()
        
        searchTextField.delegate = self
        
        trackerRecordStore.delegate = self
        completedTrackers = trackerRecordStore.completedTrackers
        completedTrackers.forEach { print($0) }
        
        trackerCategoryStore.delegate = self
        categories = trackerCategoryStore.trackerCategories
        visibleCategories = categories
        
        didChangeDate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AnalyticsService.report(
            eventName: "open_main_screen",
            params: [
                "event": "open",
                "screen": "Main"
            ]
        )
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AnalyticsService.report(
            eventName: "close_main_screen",
            params: [
                "event": "close",
                "screen": "Main"
            ]
        )
    }
    
    private func setNaviBar() {
        datePicker.addTarget(self, action: #selector(didChangeDate), for: .valueChanged)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        let leftButton = UIBarButtonItem(
            image: UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)),
            style: .plain,
            target: self,
            action: #selector(didTapAddButton))
        leftButton.tintColor = colorsForDarkLightTheme.blackWhiteDLT
        navigationItem.setLeftBarButton(leftButton, animated: false)
    }
    
    @objc private func didChangeDate() {
        if savedCheckedFilterCategory == localizableStrings.categoryNotDoneTrackers {
            reloadVisibleCategoriesWithFilterNotDoneTrackers()
        } else if savedCheckedFilterCategory == localizableStrings.categoryDoneTrackers {
            reloadVisibleCategoriesWithFilterDoneTrackers()
        } else {
            reloadVisibleCategories()
        }
    }
    
    private func reloadVisibleCategories() {
            let calendar = Calendar.current
            let filterWeekday = calendar.component(.weekday, from: datePicker.date)
            let filterText = (searchTextField.text ?? "").lowercased()
            
            visibleCategories = categories.compactMap { category in
                let trackersWithSchedule = category.trackers.filter { tracker in
                    let textCondition = filterText.isEmpty || tracker.name.lowercased().contains(filterText)
                    let dateCondition = tracker.schedule.contains { weekDay in
                        weekDay == filterWeekday
                    }
                    
                    return textCondition && dateCondition
                }
                
                let trackersWithNoSchedule = category.trackers.filter { tracker in
                    let textCondition = filterText.isEmpty || tracker.name.lowercased().contains(filterText)
                    let dateCondition = tracker.schedule.isEmpty
                    
                    return textCondition && dateCondition
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
            filterButton.isHidden = isEmpty
        
            if !isEmpty {
                let conditionForPlaceholderOption = visibleCategories.contains { category in
                    category.trackers.contains { tracker in
                        tracker.name.lowercased().contains(filterText)
                    }
                }
                backgroundImage.image = conditionForPlaceholderOption ? UIImage(named: "No_items") : UIImage(named: "NotEqualTextPlaceholder")
                backgroundTextLabel.text = localizableStrings.notEqualTextPlaceholder
        }

            trackersCollectionView.reloadData()
        }
    
    @objc private func didTapAddButton() {
        AnalyticsService.report(
            eventName: "tap_add_button",
            params: [
                "event" : "click",
                "screen" : "Main",
                "item" : "add_track"
            ]
        )
        
        let viewcontroller = NewTrackerViewController()
        viewcontroller.onAddHabitOrNonRegularEvenButtonTapped = { [weak self] savedHabitName, savedCategoryName, savedDays, savedEmoji, savedColor, savedId in
            self?.updateTrackers(savedHabitName, savedCategoryName, savedDays, savedEmoji, savedColor, savedId)
        }
        
        let navigationViewController = UINavigationController(rootViewController: viewcontroller)
        present(navigationViewController, animated: true)
    }
    
    //MARK: Creating elements on screen
    
    private func createFilterButton() {
        filterButton.backgroundColor = UIColor(named: "FilterButton")
        filterButton.setTitle(localizableStrings.filterButtonTitle, for: .normal)
        filterButton.titleLabel?.font = .systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        filterButton.setTitleColor(.white, for: .normal)
        filterButton.layer.cornerRadius = 16
        
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterButton)
        
        filterButton.addTarget(self, action: #selector(didTapFilterButton), for: .touchUpInside)
    }
    
    @objc private func didTapFilterButton() {
        AnalyticsService.report(
            eventName: "tap_filter_button",
            params: [
                "event" : "click",
                "screen" : "Main",
                "item" : "filter"
            ]
        )
        let vc = FilterMainScreenViewController()
        
        if let savedCheckedFilterCategory = savedCheckedFilterCategory {
            vc.checkedFilterCategory = savedCheckedFilterCategory
        }
        
        vc.onCategoryAllTrackersTapped = { [weak self] checkedFilterCategory in
            self?.savedCheckedFilterCategory = checkedFilterCategory
            self?.didChangeDate()
        }
        
        vc.onCategoryTodayTrackersTapped = { [weak self] checkedFilterCategory in
            self?.savedCheckedFilterCategory = checkedFilterCategory
            let currentDate = Date()
            self?.datePicker.date = currentDate
            self?.didChangeDate()
        }
        
        vc.onCategoryDoneTrackersTapped = { [weak self] checkedFilterCategory in
            self?.savedCheckedFilterCategory = checkedFilterCategory
            self?.reloadVisibleCategoriesWithFilterDoneTrackers()
        }
        
        vc.onCategoryNotDoneTrackersTapped = { [weak self] checkedFilterCategory in
            self?.savedCheckedFilterCategory = checkedFilterCategory
            self?.reloadVisibleCategoriesWithFilterNotDoneTrackers()
        }
        
        let navigationViewController = UINavigationController(rootViewController: vc)
        present(navigationViewController, animated: true)
    }
    
    private func reloadVisibleCategoriesWithFilterDoneTrackers() {
        let allTrackerRecords = trackerRecordStore.completedTrackers
        
        let filteredTrackerRecords = allTrackerRecords.filter {
            let sameDay = Calendar.current.isDate($0.date, inSameDayAs: datePicker.date)
            return sameDay
        }
        
        let allTrackersCategories = trackerCategoryStore.trackerCategories
        categories = allTrackersCategories
        
        visibleCategories = categories.compactMap { category in
            let trackersWithSameId = category.trackers.filter { tracker in
                filteredTrackerRecords.contains
                { $0.id == tracker.id }
            }
            return TrackerCategory(name: category.name, trackers: trackersWithSameId)
        }
        trackersCollectionView.reloadData()
    }
    
    private func reloadVisibleCategoriesWithFilterNotDoneTrackers() {
        let allTrackerRecords = trackerRecordStore.completedTrackers
        
        let filteredTrackerRecords = allTrackerRecords.filter {
            let sameDay = Calendar.current.isDate($0.date, inSameDayAs: datePicker.date)
            return sameDay
        }
        
        let allTrackersCategories = trackerCategoryStore.trackerCategories
        categories = allTrackersCategories
        
        let calendar = Calendar.current
        let filterWeekday = calendar.component(.weekday, from: datePicker.date)
        
        visibleCategories = categories.compactMap { category in
            let trackersWithNotSameId = category.trackers.filter { tracker in
                let notDoneTrackersCondition = !filteredTrackerRecords.contains { $0.id == tracker.id }
                let scheduleCondition = tracker.schedule.contains { weekday in
                    weekday == filterWeekday
                }
                return notDoneTrackersCondition && scheduleCondition
            }
            return TrackerCategory(name: category.name, trackers: trackersWithNotSameId)
        }
        trackersCollectionView.reloadData()
    }
    
    private func createTitleLabel() {
        titleLabel.text = localizableStrings.title
        titleLabel.textColor = colorsForDarkLightTheme.blackWhiteDLT
        titleLabel.font = .systemFont(ofSize: 34, weight: UIFont.Weight.bold)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
    }
    
    private func createBackgroundImage() {
        backgroundImage.image = UIImage(named: "No_items")
        
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImage)
    }
    
    private func createBackgroundTextLabel() {
        backgroundTextLabel.text = localizableStrings.placeholderTitle
        backgroundTextLabel.textColor = colorsForDarkLightTheme.blackWhiteDLT
        backgroundTextLabel.font = .systemFont(ofSize: 12, weight: UIFont.Weight.medium)
        
        backgroundTextLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundTextLabel)
    }
    
    private func createSearchTextField() {
        searchTextField.backgroundColor = colorsForDarkLightTheme.backgroundColorSearchTextFieldTrackVC
        searchTextField.textColor = colorsForDarkLightTheme.blackWhiteDLT
        searchTextField.font = UIFont.systemFont(ofSize: 17)
        searchTextField.attributedPlaceholder = NSAttributedString(string: localizableStrings.searchTextFiledPlaceholderText, attributes: [NSAttributedString.Key.foregroundColor: colorsForDarkLightTheme.placeholderSearchTextFieldTextColorTrackVC ?? UIColor()])
        
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
            trackersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 131),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -130),
            filterButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    //MARK: Helpers
    
    private func updateTrackers(_ savedHabitName: String, _ savedCategoryName: String, _ savedDays: [String], _ savedEmoji: String, _ savedColor: UIColor, _ savedId: UUID? ) {
        print(savedEmoji)
        backgroundImage.isHidden = true
        backgroundTextLabel.isHidden = true
        trackersCollectionView.isHidden = false
        
        let convertedDays = convertSavedDaysToNumbersOfWeekend(savedDays)
        
        if let savedId = savedId {
            let updateTracker = Tracker(id: savedId, name: savedHabitName, color: uiColorMarshalling.hexString(from: savedColor), emoji: savedEmoji, schedule: convertedDays)
            dataProvider.updateTracker(updatingTracker: updateTracker, updateCategoryName: savedCategoryName)
            categories = trackerCategoryStore.trackerCategories
        } else {
            let tracker = Tracker(
                id: UUID(),
                name: savedHabitName,
                color: uiColorMarshalling.hexString(from: savedColor),
                emoji: savedEmoji,
                schedule: convertedDays
            )
            
            dataProvider.addTracker(categoryName: savedCategoryName, tracker: tracker)
        }
        
        didChangeDate()
    }
    
    private func convertSavedDaysToNumbersOfWeekend(_ savedDays: [String]) -> [Int] {
        return convertScheduleDays.convertStringDaysToInt(savedDays)
    }
    
    private func pinTracker(indexPath: IndexPath) {
        
    }
    
    private func editTracker(tracker: Tracker, categoryName: String, isTrackerIsEditing: Bool, completedDays: String) {
        AnalyticsService.report(
            eventName: "edit_tracker",
            params: [
                "event" : "click",
                "screen" : "Main",
                "item" : "edit"
            ]
        )
        
        let editHabitOrNonRegularEventVC = NewHabitOrNonRegularEventViewController(editTracker: tracker, categoryName: categoryName, completedDays: completedDays, isTrackerIsEditing: true)
        
        if tracker.schedule.isEmpty {
            editHabitOrNonRegularEventVC.categoriesAndSchedule = ["Категория"]
        } else {
            editHabitOrNonRegularEventVC.categoriesAndSchedule = ["Категория", "Расписание"]
        }
        
        editHabitOrNonRegularEventVC.onAddHabitButtonTapped = { [weak self] savedHabitName, savedCategoryName, savedDays, savedEmoji, savedColor, savedId in
            self?.updateTrackers(savedHabitName, savedCategoryName, savedDays, savedEmoji, savedColor, savedId)
        }
        
        let navigationViewController = UINavigationController(rootViewController: editHabitOrNonRegularEventVC)
        present(navigationViewController, animated: true)
    }
    
    private func deleteTracker(id: UUID) {
        AnalyticsService.report(
            eventName: "delete_tracker",
            params: [
                "event" : "click",
                "screen" : "Main",
                "item" : "delete"
            ]
        )
        
        dataProvider.removeTracker(id: id)
    }
}

extension TrackersViewController: TrackerCategoryStoreDelegate {
    func trackerStore(_ store: TrackerCategoryStore, didUpdate update: TrackerCategoryStoreUpdate) {
        categories = store.trackerCategories
        
        visibleCategories = categories
        
        didChangeDate()
    }
}

extension TrackersViewController: TrackerRecordStoreDelegate {
    func trackerRecordStore(_ trackerRecordStore: TrackerRecordStore, didUpdate update: TrackerRecordStoreUpdate) {
        completedTrackers = trackerRecordStore.completedTrackers
        
        trackersCollectionView.reloadData()
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
        
        let color = uiColorMarshalling.color(from: tracker.color)
        let isCompletedToday = isTrackerCompletedToday(id: tracker.id)
        let completedDays = completedTrackers.filter {
            $0.id == tracker.id
        }.count
        
        cell.configure(with: tracker, isCompletedToday: isCompletedToday, completedDays: completedDays, color: color)
        
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
        
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? TrackersCollectionSupplementaryView else { return UICollectionViewCell() }
        
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
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let cell = collectionView.cellForItem(at: indexPath) as? TrackersCollectionCell
        guard let colorBack = cell?.habitCardColorLabel.layer.backgroundColor,
              let emoji = cell?.emojiLabel.text,
              let habitName = cell?.habitNameLabel.text,
              let id = cell?.trackerId else { return nil }
        
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        guard let completedDays = cell?.dayLabel.text else {
            print("contextMenuConfigurationForItemAt")
            return UIContextMenuConfiguration()
        }
        
        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: {
                let vc = TrackerCellPreviewViewController(
                    colorBack: colorBack,
                    emoji: emoji,
                    habitName: habitName
                )
                
                return vc
            },
            actionProvider: { actions in
                return UIMenu(children: [
                    UIAction(title: "Закрепить") { [weak self] _ in
                        self?.pinTracker(indexPath: indexPath)
                    },
                    UIAction(title: "Редактировать") { [weak self] _ in
                        self?.editTracker(tracker: tracker, categoryName: "Placeholder", isTrackerIsEditing: true, completedDays: completedDays)
                    },
                    UIAction(title: "Удалить", attributes: .destructive) { [weak self] _ in
                        self?.deleteTracker(id: id)
                    }
                ])
            })
    }
}

//MARK: CollectionCell Delegate Protocol

extension TrackersViewController: TrackersCollectionCellDelegate {
    func completeTracker(id: UUID) {
        AnalyticsService.report(
            eventName: "tap_plus_day",
            params: [
                "event" : "click",
                "screen" : "Main",
                "item" : "track"
            ]
        )
        
        let sameDay = Calendar.current.isDate(currentDate, inSameDayAs: datePicker.date)
        
        // validDay - проверка на то, что в datePicker выбран текущий день или прошедшая дата для чека трека
        let validDay = currentDate > datePicker.date || sameDay
        
        if validDay {
            let trackerRecord = TrackerRecord(id: id, date: datePicker.date)
            dataProvider.addTrackerRecord(trackerRecord: trackerRecord)
        } else {
            print("Cant add day")
        }
    }
    
    func uncompleteTracker(id: UUID) {
        AnalyticsService.report(
            eventName: "tap_minus_day",
            params: [
                "event" : "click",
                "screen" : "Main",
                "item" : "track"
            ]
        )
        
        let sameDay = Calendar.current.isDate(currentDate, inSameDayAs: datePicker.date)
        
        // validDay - проверка на то, что в datePicker выбран текущий день или прошедшая дата для чека трека
        let validDay = currentDate > datePicker.date || sameDay
        
        if validDay {
            let trackerRecord = TrackerRecord(id: id, date: datePicker.date)
            print(trackerRecord.date)
            dataProvider.remove(trackerRecord)
        } else {
            print("Cant remove day")
        }
    }
}

//MARK: TextField Delegate Protocol

extension TrackersViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        reloadVisibleCategories()
        return true
    }
}

