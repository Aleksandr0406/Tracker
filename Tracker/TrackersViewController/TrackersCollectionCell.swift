//
//  TrackersCollectionViewCell.swift
//  Tracker
//
//  Created by 1111 on 23.02.2025.
//

import UIKit

protocol TrackersCollectionCellDelegate: AnyObject {
    func completeTracker(id: UUID, at indexPath: IndexPath)
    func uncompleteTracker(id: UUID, at indexPath: IndexPath)
}

final class TrackersCollectionCell: UICollectionViewCell {
    static let cellIdentifier = "Cell"
    
    let habitCardColorLabel: UILabel = UILabel()
    let emojiLabel: UILabel = UILabel()
    let emojiImage: UIImageView = UIImageView()
    let habitNameLabel: UILabel = UILabel()
    let addDayButton: UIButton = UIButton()
    let dayLabel: UILabel = UILabel()
    
    weak var delegate: TrackersCollectionCellDelegate?
    
    private var isCompletedToday: Bool = false
    private var trackerId: UUID?
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
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with tracker: Tracker, isCompletedToday: Bool, indexPath: IndexPath, completedDays: Int) {
        self.trackerId = tracker.id
        self.isCompletedToday = isCompletedToday
        self.indexPath = indexPath
        
        emojiLabel.text = "❤️"
        habitNameLabel.text = tracker.name
        
        let completedDaysString = "\(completedDays) день"
        dayLabel.text = completedDaysString
        
        let backButtonColor = isCompletedToday ? UIColor(named: "33CF69_30%") : UIColor(named: "33CF69")
        addDayButton.backgroundColor = backButtonColor
        
        let image = isCompletedToday ? doneImage : plusImage
        addDayButton.setImage(image, for: .normal)
    }
    
    private func createHabitCardColorLabel() {
        habitCardColorLabel.layer.backgroundColor = UIColor(named: "33CF69")?.cgColor
        habitCardColorLabel.layer.cornerRadius = 16
        
        habitCardColorLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(habitCardColorLabel)
    }
    
    private func createEmojiImage() {
        emojiImage.image = UIImage(named: "Emoji")
        emojiImage.contentMode = .center
        
        emojiImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emojiImage)
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
        addDayButton.tintColor = .white
        addDayButton.layer.cornerRadius = 17
        addDayButton.setImage(plusImage, for: .normal)
        
        addDayButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(addDayButton)
        
        addDayButton.addTarget(self, action: #selector(didTapAddDayButton), for: .touchUpInside)
    }
    
    @objc private func didTapAddDayButton() {
        guard let indexPath = indexPath,
              let trackerId = trackerId else { return }
        
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
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            habitCardColorLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            habitCardColorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            habitCardColorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            habitCardColorLabel.heightAnchor.constraint(equalToConstant: 90),
            
            emojiImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            emojiImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            emojiImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -131),
            emojiImage.heightAnchor.constraint(equalToConstant: 24),
            emojiImage.widthAnchor.constraint(equalToConstant: 24),
            
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



