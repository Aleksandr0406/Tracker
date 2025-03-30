//
//  TrackersCollectionViewCell.swift
//  Tracker
//
//  Created by 1111 on 23.02.2025.
//

import UIKit

protocol TrackersCollectionCellDelegate: AnyObject {
    func completeTracker(id: UUID)
    func uncompleteTracker(id: UUID)
}

final class TrackersCollectionCell: UICollectionViewCell {
    static let cellIdentifier = "Cell"
    
    let colorsForDarkLightTheme: ColorsForDarkLightTheme = ColorsForDarkLightTheme()
    
    let habitCardColorLabel: UILabel = UILabel()
    let emojiLabel: UILabel = UILabel()
    let emojiBackLabel: UILabel = UILabel()
    let habitNameLabel: UILabel = UILabel()
    let addDayButton: UIButton = UIButton()
    let dayLabel: UILabel = UILabel()
    
    weak var delegate: TrackersCollectionCellDelegate?
    
    private let localizableStrings: LocalizableStringsTrackersCollectionCell = LocalizableStringsTrackersCollectionCell()
    private var isCompletedToday: Bool = false
    private var trackerId: UUID?
    private let doneImage = UIImage(named: "Check_Tracker")
    private let plusImage: UIImage = {
        let pointSize = UIImage.SymbolConfiguration(pointSize: 11)
        let image = UIImage(systemName: "plus", withConfiguration: pointSize) ?? UIImage()
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createHabitCardColorLabel()
        createEmojiBackLabel()
        createEmojiLabel()
        createHabitNameLabel()
        createAddDayButton()
        createDayLabel()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with tracker: Tracker, isCompletedToday: Bool, completedDays: Int, color: UIColor) {
        self.trackerId = tracker.id
        self.isCompletedToday = isCompletedToday
        
        emojiLabel.text = tracker.emoji
        habitNameLabel.text = tracker.name
        
        if completedDays <= 1 {
            let completedDaysString = "\(completedDays) " + localizableStrings.dayLoc
        dayLabel.text = completedDaysString
        } else {
            let completedDaysString = "\(completedDays) " + localizableStrings.daysLoc
            dayLabel.text = completedDaysString
        }
    
        habitCardColorLabel.layer.backgroundColor = color.cgColor
        
        let image = isCompletedToday ? doneImage : plusImage
        addDayButton.setImage(image, for: .normal)
        addDayButton.backgroundColor = isCompletedToday ? color.withAlphaComponent(0.3) : color
    }
    
    private func createHabitCardColorLabel() {
        habitCardColorLabel.layer.cornerRadius = 16
        
        habitCardColorLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(habitCardColorLabel)
    }
    
    private func createEmojiBackLabel() {
        emojiBackLabel.layer.backgroundColor = UIColor(named: "EmojiBack")?.cgColor
        emojiBackLabel.layer.cornerRadius = 12
        
        emojiBackLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emojiBackLabel)
    }
    
    private func createEmojiLabel() {
        emojiLabel.font = .systemFont(ofSize: 16)
        emojiLabel.textAlignment = .center
        emojiLabel.adjustsFontSizeToFitWidth = true
        
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emojiLabel)
    }
    
    private func createHabitNameLabel() {
        habitNameLabel.adjustsFontSizeToFitWidth = true
        habitNameLabel.textAlignment = .left
        habitNameLabel.font = .systemFont(ofSize: 12)
        habitNameLabel.textColor = .white
        habitNameLabel.numberOfLines = 2
        
        habitNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(habitNameLabel)
    }
    
    private func createAddDayButton() {
        addDayButton.tintColor = colorsForDarkLightTheme.whiteBlackDLT
        addDayButton.layer.cornerRadius = 17
        addDayButton.setImage(plusImage, for: .normal)
        
        addDayButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(addDayButton)
        
        addDayButton.addTarget(self, action: #selector(didTapAddDayButton), for: .touchUpInside)
    }
    
    @objc private func didTapAddDayButton() {
        guard let trackerId = trackerId else { return }
        
        if isCompletedToday {
            delegate?.uncompleteTracker(id: trackerId)
        } else {
            delegate?.completeTracker(id: trackerId)
        }
    }
    
    private func createDayLabel() {
        dayLabel.adjustsFontSizeToFitWidth = true
        dayLabel.textAlignment = .left
        dayLabel.font = .systemFont(ofSize: 12)
        dayLabel.textColor = colorsForDarkLightTheme.blackWhiteDLT
        dayLabel.backgroundColor = colorsForDarkLightTheme.whiteBlackDLT
        
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dayLabel)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            habitCardColorLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            habitCardColorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            habitCardColorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            habitCardColorLabel.heightAnchor.constraint(equalToConstant: 90),
            
            emojiBackLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            emojiBackLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            emojiBackLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -131),
            emojiBackLabel.heightAnchor.constraint(equalToConstant: 24),
            emojiBackLabel.widthAnchor.constraint(equalToConstant: 24),
            
            emojiLabel.topAnchor.constraint(equalTo: emojiBackLabel.topAnchor, constant: 1),
            emojiLabel.leadingAnchor.constraint(equalTo: emojiBackLabel.leadingAnchor, constant: 4),
            emojiLabel.trailingAnchor.constraint(equalTo: emojiBackLabel.trailingAnchor, constant: -4),
            emojiLabel.bottomAnchor.constraint(equalTo: emojiBackLabel.bottomAnchor, constant: -1),
            
            habitNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 44),
            habitNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            habitNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            habitNameLabel.heightAnchor.constraint(equalToConstant: 34),
            
            addDayButton.topAnchor.constraint(equalTo: habitCardColorLabel.bottomAnchor, constant: 8),
            addDayButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            addDayButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            addDayButton.heightAnchor.constraint(equalToConstant: 34),
            addDayButton.widthAnchor.constraint(equalToConstant: 34),
            
            dayLabel.topAnchor.constraint(equalTo: habitCardColorLabel.bottomAnchor, constant: 16),
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            dayLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            dayLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}



