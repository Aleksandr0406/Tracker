//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by 1111 on 30.01.2025.
//

import UIKit

final class StatisticsViewController: UIViewController {
    private let localizableStrings: LocalizableStringsStatisticsViewController = LocalizableStringsStatisticsViewController()
    
    private let trackerStore: TrackerStore = TrackerStore()
    private let trackerCategoriesStore: TrackerCategoryStore = TrackerCategoryStore()
    private let trackerRecordStore: TrackerRecordStore = TrackerRecordStore()
    
    private var allTrackerRecords: [TrackerRecord] {
        let allTrackerRecords = trackerRecordStore.completedTrackers
        return allTrackerRecords
    }
    
    private var allTrackers: [Tracker] {
        var trackers: [Tracker] = []
        let allTrackersCategories = trackerCategoriesStore.trackerCategories
        allTrackersCategories.forEach { trackers += $0.trackers }
        return trackers
    }
    
    private var trackersCompletedValue: Int {
        let trackersCompletedValue = trackerRecordStore.completedTrackers.count
        return trackersCompletedValue
    }
    
    private var titleLabel: UILabel = UILabel()
    private var placeholderTextLabel: UILabel = UILabel()
    private var placeholderImageView: UIImageView = UIImageView()
    
    private var bestPeriodBorderView: GradientBorderView = GradientBorderView()
    private var bestPeriodTitleLabel: UILabel = UILabel()
    private var bestPeriodNumberValueLabel: UILabel = UILabel()
    
    private var idealDaysBorderView: GradientBorderView = GradientBorderView()
    private var idealDaysTitleLabel: UILabel = UILabel()
    private var idealDaysNumberValueLabel: UILabel = UILabel()
    
    private var trackersCompletedBorderView: GradientBorderView = GradientBorderView()
    private var trackersCompletedTitleLabel: UILabel = UILabel()
    private var trackersCompletedNumberValueLabel: UILabel = UILabel()
    
    private var averageValueBorderView: GradientBorderView = GradientBorderView()
    private var averageValueTitleLabel: UILabel = UILabel()
    private var averageValueNumberValueLabel: UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTitleLabel()
        createPlaceholderImageView()
        createPlaceholderTextLabel()
        
        createBestPeriodLabel()
        createBestPeriodNumberValueLabel()
        createBestPeriodTitleLabel()
        
        createIdealDaysLabel()
        createIdealDaysNumberValueLabel()
        createIdealDaysTitleLabel()
        
        createTrackersCompletedLabel()
        createTrackersCompletedNumberValueLabel()
        createTrackersCompletedTitleLabel()
        
        createAverageValueLabel()
        createAverageValueNumberValueLabel()
        createAverageValueTitleLabel()
        
        setConstraints()
        checkToHidePlaceholder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkToHidePlaceholder()
        
        countBestPeriodAndSetToLabel()
        countIdealDaysAndSetToLabel()
        countCompletedTrackersAndSetToLabel()
        countAverageValueAndSetToLabel()
    }
    
    private func checkToHidePlaceholder() {
        if trackersCompletedValue > 0 || allTrackers.count > 0 {
            placeholderImageView.isHidden = true
            placeholderTextLabel.isHidden = true
            
            bestPeriodBorderView.isHidden = false
            bestPeriodTitleLabel.isHidden = false
            bestPeriodNumberValueLabel.isHidden = false
            
            idealDaysBorderView.isHidden = false
            idealDaysTitleLabel.isHidden = false
            idealDaysNumberValueLabel.isHidden = false
            
            trackersCompletedBorderView.isHidden = false
            trackersCompletedTitleLabel.isHidden = false
            trackersCompletedNumberValueLabel.isHidden = false
            
            averageValueBorderView.isHidden = false
            averageValueTitleLabel.isHidden = false
            averageValueNumberValueLabel.isHidden = false
        }
    }
    
    private func createTitleLabel() {
        titleLabel.text = localizableStrings.statisticsTitle
        titleLabel.font = .systemFont(ofSize: 34, weight: UIFont.Weight.bold)
        titleLabel.textAlignment = .left
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
    }
    
    private func createPlaceholderTextLabel() {
        placeholderTextLabel.text = localizableStrings.placeHolderTitle
        placeholderTextLabel.font = .systemFont(ofSize: 12, weight: UIFont.Weight.medium)
        placeholderTextLabel.textAlignment = .center
        
        placeholderTextLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(placeholderTextLabel)
    }
    
    private func createPlaceholderImageView() {
        placeholderImageView.image = UIImage(named: "StatisticsPlaceholderImage")
        
        placeholderImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(placeholderImageView)
    }
    
    private func createBestPeriodLabel() {
        bestPeriodBorderView.clipsToBounds = true
        bestPeriodBorderView.layer.cornerRadius = 16
        bestPeriodBorderView.isHidden = true
        
        bestPeriodBorderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bestPeriodBorderView)
    }
    
    private func createBestPeriodTitleLabel() {
        bestPeriodTitleLabel.text = localizableStrings.bestPeriod
        bestPeriodTitleLabel.font = .systemFont(ofSize: 12, weight: UIFont.Weight.medium)
        bestPeriodTitleLabel.textAlignment = .left
        bestPeriodTitleLabel.isHidden = true
        
        bestPeriodTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bestPeriodTitleLabel)
    }
    
    private func createBestPeriodNumberValueLabel() {
        bestPeriodNumberValueLabel.font = .systemFont(ofSize: 34, weight: UIFont.Weight.bold)
        bestPeriodNumberValueLabel.textAlignment = .left
        bestPeriodNumberValueLabel.isHidden = true
        
        bestPeriodNumberValueLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bestPeriodNumberValueLabel)
    }
    
    private func createIdealDaysLabel() {
        bestPeriodBorderView.clipsToBounds = true
        idealDaysBorderView.layer.cornerRadius = 16
        idealDaysBorderView.isHidden = true
        
        idealDaysBorderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(idealDaysBorderView)
    }
    
    private func createIdealDaysTitleLabel() {
        idealDaysTitleLabel.text = localizableStrings.idealDays
        idealDaysTitleLabel.font = .systemFont(ofSize: 12, weight: UIFont.Weight.medium)
        idealDaysTitleLabel.textAlignment = .left
        idealDaysTitleLabel.isHidden = true
        
        idealDaysTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(idealDaysTitleLabel)
    }
    
    private func createIdealDaysNumberValueLabel() {
        idealDaysNumberValueLabel.font = .systemFont(ofSize: 34, weight: UIFont.Weight.bold)
        idealDaysNumberValueLabel.textAlignment = .left
        idealDaysNumberValueLabel.isHidden = true
        
        idealDaysNumberValueLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(idealDaysNumberValueLabel)
    }
    
    private func createTrackersCompletedLabel() {
        bestPeriodBorderView.clipsToBounds = true
        trackersCompletedBorderView.layer.cornerRadius = 16
        trackersCompletedBorderView.isHidden = true
        
        trackersCompletedBorderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackersCompletedBorderView)
    }
    
    private func createTrackersCompletedTitleLabel() {
        trackersCompletedTitleLabel.text = localizableStrings.trackersCompleted
        trackersCompletedTitleLabel.font = .systemFont(ofSize: 12, weight: UIFont.Weight.medium)
        trackersCompletedTitleLabel.textAlignment = .left
        trackersCompletedTitleLabel.isHidden = true
        
        trackersCompletedTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackersCompletedTitleLabel)
    }
    
    private func createTrackersCompletedNumberValueLabel() {
        trackersCompletedNumberValueLabel.font = .systemFont(ofSize: 34, weight: UIFont.Weight.bold)
        trackersCompletedNumberValueLabel.textAlignment = .left
        trackersCompletedNumberValueLabel.isHidden = true
        
        trackersCompletedNumberValueLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackersCompletedNumberValueLabel)
    }
    
    private func createAverageValueLabel() {
        bestPeriodBorderView.clipsToBounds = true
        averageValueBorderView.layer.cornerRadius = 16
        averageValueBorderView.isHidden = true
        
        averageValueBorderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(averageValueBorderView)
    }
    
    private func createAverageValueTitleLabel() {
        averageValueTitleLabel.text = localizableStrings.averageValue
        averageValueTitleLabel.font = .systemFont(ofSize: 12, weight: UIFont.Weight.medium)
        averageValueTitleLabel.textAlignment = .left
        averageValueTitleLabel.isHidden = true
        
        averageValueTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(averageValueTitleLabel)
    }
    
    private func createAverageValueNumberValueLabel() {
        averageValueNumberValueLabel.text = "1"
        averageValueNumberValueLabel.font = .systemFont(ofSize: 34, weight: UIFont.Weight.bold)
        averageValueNumberValueLabel.textAlignment = .left
        averageValueNumberValueLabel.isHidden = true
        averageValueNumberValueLabel.lineBreakMode = .byCharWrapping
        
        averageValueNumberValueLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(averageValueNumberValueLabel)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.heightAnchor.constraint(equalToConstant: 41),
            
            placeholderImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholderImageView.heightAnchor.constraint(equalToConstant: 80),
            placeholderImageView.widthAnchor.constraint(equalToConstant: 80),
            
            placeholderTextLabel.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: 8),
            placeholderTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderTextLabel.heightAnchor.constraint(equalToConstant: 18),
            
            bestPeriodBorderView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 77),
            bestPeriodBorderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bestPeriodBorderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bestPeriodBorderView.heightAnchor.constraint(equalToConstant: 90),
            
            bestPeriodNumberValueLabel.topAnchor.constraint(equalTo: bestPeriodBorderView.topAnchor, constant: 12),
            bestPeriodNumberValueLabel.leadingAnchor.constraint(equalTo: bestPeriodBorderView.leadingAnchor, constant: 12),
            bestPeriodNumberValueLabel.heightAnchor.constraint(equalToConstant: 41),
            
            bestPeriodTitleLabel.bottomAnchor.constraint(equalTo: bestPeriodBorderView.bottomAnchor, constant: -12),
            bestPeriodTitleLabel.leadingAnchor.constraint(equalTo: bestPeriodBorderView.leadingAnchor, constant: 12),
            bestPeriodTitleLabel.heightAnchor.constraint(equalToConstant: 18),
            
            idealDaysBorderView.topAnchor.constraint(equalTo: bestPeriodBorderView.bottomAnchor, constant: 12),
            idealDaysBorderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            idealDaysBorderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            idealDaysBorderView.heightAnchor.constraint(equalToConstant: 90),
            
            idealDaysNumberValueLabel.topAnchor.constraint(equalTo: idealDaysBorderView.topAnchor, constant: 12),
            idealDaysNumberValueLabel.leadingAnchor.constraint(equalTo: idealDaysBorderView.leadingAnchor, constant: 12),
            idealDaysNumberValueLabel.heightAnchor.constraint(equalToConstant: 41),
            
            idealDaysTitleLabel.bottomAnchor.constraint(equalTo: idealDaysBorderView.bottomAnchor, constant: -12),
            idealDaysTitleLabel.leadingAnchor.constraint(equalTo: idealDaysBorderView.leadingAnchor, constant: 12),
            idealDaysTitleLabel.heightAnchor.constraint(equalToConstant: 18),
            
            trackersCompletedBorderView.topAnchor.constraint(equalTo: idealDaysBorderView.bottomAnchor, constant: 12),
            trackersCompletedBorderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackersCompletedBorderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackersCompletedBorderView.heightAnchor.constraint(equalToConstant: 90),
            
            trackersCompletedNumberValueLabel.topAnchor.constraint(equalTo: trackersCompletedBorderView.topAnchor, constant: 12),
            trackersCompletedNumberValueLabel.leadingAnchor.constraint(equalTo: trackersCompletedBorderView.leadingAnchor, constant: 12),
            trackersCompletedNumberValueLabel.heightAnchor.constraint(equalToConstant: 41),
            
            trackersCompletedTitleLabel.bottomAnchor.constraint(equalTo: trackersCompletedBorderView.bottomAnchor, constant: -12),
            trackersCompletedTitleLabel.leadingAnchor.constraint(equalTo: trackersCompletedBorderView.leadingAnchor, constant: 12),
            trackersCompletedTitleLabel.heightAnchor.constraint(equalToConstant: 18),
            
            averageValueBorderView.topAnchor.constraint(equalTo: trackersCompletedBorderView.bottomAnchor, constant: 12),
            averageValueBorderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            averageValueBorderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            averageValueBorderView.heightAnchor.constraint(equalToConstant: 90),
            
            averageValueNumberValueLabel.topAnchor.constraint(equalTo: averageValueBorderView.topAnchor, constant: 12),
            averageValueNumberValueLabel.leadingAnchor.constraint(equalTo: averageValueBorderView.leadingAnchor, constant: 12),
            averageValueNumberValueLabel.trailingAnchor.constraint(equalTo: averageValueBorderView.trailingAnchor, constant: -12),
            averageValueNumberValueLabel.heightAnchor.constraint(equalToConstant: 41),
            
            
            averageValueTitleLabel.bottomAnchor.constraint(equalTo: averageValueBorderView.bottomAnchor, constant: -12),
            averageValueTitleLabel.leadingAnchor.constraint(equalTo: averageValueBorderView.leadingAnchor, constant: 12),
            averageValueTitleLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    private func countBestPeriodAndSetToLabel() {
        
        var bestPeriod = 0
        let calendar = Calendar.current
        
        for tracker in allTrackers {
            let trackerRecords = allTrackerRecords
                .filter { $0.id == tracker.id }
                .sorted { $0.date < $1.date }
            
            var currentBestPeriod = 1
            guard trackerRecords.count > 1 else {
                bestPeriod = max(bestPeriod, currentBestPeriod)
                continue
            }
            
            for i in 1..<trackerRecords.count {
                let previousDate = trackerRecords[i - 1].date
                let currentDate = trackerRecords[i].date
                
                guard let nextDate = calendar.date(byAdding: .day, value: 1, to: previousDate) else {
                    continue
                }
                
                if calendar.isDate(currentDate, inSameDayAs: nextDate) {
                    currentBestPeriod += 1
                } else {
                    bestPeriod = max(bestPeriod, currentBestPeriod)
                    currentBestPeriod = 1
                }
            }
            
            bestPeriod = max(bestPeriod, currentBestPeriod)
        }
        
        bestPeriodNumberValueLabel.text = "\(bestPeriod)"
    }
    
    private func countIdealDaysAndSetToLabel() {
        var idealDays: Int = 0
        var newTrackersRecord: [Date] = []
        var newTrackers: [Tracker] = []
        var checkedTrackerRecordDays: [Date] = []
        var check: Bool = false
        
        for trackerRecord in allTrackerRecords {
            
            if !checkedTrackerRecordDays.isEmpty {
                for index in 0...(checkedTrackerRecordDays.count - 1) {
                    check = checkedTrackerRecordDays.contains { checkTrackerRecord in
                        let sameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: checkedTrackerRecordDays[index])
                        return sameDay
                    }
                }
            }
            
            if check {
                print("do nothing")
            } else {
                for index in 0...(allTrackerRecords.count - 1) {
                    let sameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: allTrackerRecords[index].date)
                    if sameDay {
                        newTrackersRecord.append(trackerRecord.date)
                    }
                }
                
                let newTrackersRecordCount = newTrackersRecord.count
                
                let calendar = Calendar.current
                let filterWeekday = calendar.component(.weekday, from: trackerRecord.date)
                
                allTrackers.forEach { tracker in
                    
                    if tracker.schedule.isEmpty {
                        newTrackers.append(tracker)
                    } else {
                        tracker.schedule.forEach { weekday in
                            
                            if weekday == filterWeekday {
                                newTrackers.append(tracker)
                            }
                        }
                    }
                }
                
                let newTrackersCount = newTrackers.count
                
                if newTrackersRecordCount == newTrackersCount {
                    idealDays += 1
                }
            }
            
            newTrackersRecord = []
            newTrackers = []
            checkedTrackerRecordDays.append(trackerRecord.date)
        }
        
        idealDaysNumberValueLabel.text = "\(idealDays)"
    }
    
    private func countCompletedTrackersAndSetToLabel() {
        trackersCompletedNumberValueLabel.text = "\(trackersCompletedValue)"
    }
    
    private func countAverageValueAndSetToLabel() {
        var dateCounts: [Date : Int] = [:]
        let calendar = Calendar.current
        
        for record in allTrackerRecords {
            let date = calendar.startOfDay(for: record.date)
            dateCounts[date, default: 0] += 1
        }
        
        let total = dateCounts.values.reduce(0, +)
        let averageValue = Double(total) / Double(dateCounts.count)
        averageValueNumberValueLabel.text = "\(averageValue)"
    }
}
