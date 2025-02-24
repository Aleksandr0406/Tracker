//
//  TrackersCollectionViewCell.swift
//  Tracker
//
//  Created by 1111 on 23.02.2025.
//

import Foundation
import UIKit

protocol TrackersCollectionCellDelegate: AnyObject {
    func completeTracker(id: String, at indexPath: IndexPath)
    func uncompleteTracker(id: String, at indexPath: IndexPath)
}

final class TrackersCollectionCell: UICollectionViewCell {
    static let cellIdentifier = "Cell"
    
    weak var delegate: TrackersCollectionCellDelegate?
    
    let habitCardColorLabel: UILabel = UILabel()
    let emojiLabel: UILabel = UILabel()
    let emojiImage: UIImageView = UIImageView()
    let habitNameLabel: UILabel = UILabel()
    let addDayButton: UIButton = UIButton()
    let dayLabel: UILabel = UILabel()
    
    private var isCompletedToday: Bool = false
    private var trackerId: String = ""
    private var indexPath: IndexPath?
    
    private let doneImage = UIImage(named: "Check_Tracker")
    private let plusImage: UIImage = {
        let pointSize = UIImage.SymbolConfiguration(pointSize: 11)
        let image = UIImage(systemName: "plus", withConfiguration: pointSize) ?? UIImage()
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createHabitCardColorLabel()
        createEmojiImage()
        createHabitNameLabel()
        createAddDayButton()
        createDayLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with tracker: Tracker, isCompletedToday: Bool, indexPath: IndexPath, completedDays: Int) {
        //        self.trackerId = tracker.id
        self.isCompletedToday = isCompletedToday
        self.indexPath = indexPath
        
        emojiLabel.text = "❤️"
        habitNameLabel.text = tracker.name
        
        let word = plusOneDay(completedDays)
        dayLabel.text = word
        
        let backButtonColor = isCompletedToday ? UIColor(named: "33CF69_30%") : UIColor(named: "33CF69")
        addDayButton.backgroundColor = backButtonColor
        
        let image = isCompletedToday ? doneImage : plusImage
        addDayButton.setImage(image, for: .normal)
    }
    
    private func plusOneDay(_ oneDay: Int) -> String {
        var sumDay: Int = 0
        sumDay = sumDay + oneDay
        return "\(sumDay) день"
    }
    
    private func createHabitCardColorLabel() {
        habitCardColorLabel.layer.backgroundColor = UIColor(named: "33CF69")?.cgColor
        habitCardColorLabel.layer.cornerRadius = 16
        
        habitCardColorLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(habitCardColorLabel)
        
        habitCardColorLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        habitCardColorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        habitCardColorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        habitCardColorLabel.heightAnchor.constraint(equalToConstant: 90).isActive = true
    }
    
    private func createEmojiImage() {
        emojiImage.image = UIImage(named: "Emoji")
        emojiImage.contentMode = .center
        
        emojiImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emojiImage)
        
        emojiImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        emojiImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        emojiImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -131).isActive = true
        emojiImage.heightAnchor.constraint(equalToConstant: 24).isActive = true
        emojiImage.widthAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    private func createHabitNameLabel() {
        habitNameLabel.adjustsFontSizeToFitWidth = true
        habitNameLabel.textAlignment = .left
        habitNameLabel.font = .systemFont(ofSize: 12)
        habitNameLabel.textColor = .white
        habitNameLabel.numberOfLines = 2
        
        habitNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(habitNameLabel)
        
        habitNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 44).isActive = true
        habitNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        habitNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
        habitNameLabel.heightAnchor.constraint(equalToConstant: 34).isActive = true
    }
    
    private func createAddDayButton() {
        addDayButton.tintColor = .white
        addDayButton.layer.cornerRadius = 17
        
        addDayButton.setImage(plusImage, for: .normal)
        
        addDayButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(addDayButton)
        
        addDayButton.topAnchor.constraint(equalTo: habitCardColorLabel.bottomAnchor, constant: 8).isActive = true
        addDayButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
        addDayButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        addDayButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        addDayButton.widthAnchor.constraint(equalToConstant: 34).isActive = true
        
        addDayButton.addTarget(self, action: #selector(didTapAddDayButton), for: .touchUpInside)
    }
    
    @objc private func didTapAddDayButton() {
        guard let indexPath = indexPath else { return }
        
        if isCompletedToday {
            delegate?.uncompleteTracker(id: trackerId, at: indexPath)
        } else {
            delegate?.completeTracker(id: trackerId, at: indexPath)
        }
    }
    
    private func createDayLabel() {
        dayLabel.adjustsFontSizeToFitWidth = true
        dayLabel.textAlignment = .left
        dayLabel.font = .systemFont(ofSize: 12)
        dayLabel.textColor = .black
        dayLabel.backgroundColor = .white
        
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dayLabel)
        
        dayLabel.topAnchor.constraint(equalTo: habitCardColorLabel.bottomAnchor, constant: 16).isActive = true
        dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        dayLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24).isActive = true
        dayLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
    }
}



