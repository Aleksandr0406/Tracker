//
//  TrackersCollectionViewCell.swift
//  Tracker
//
//  Created by 1111 on 23.02.2025.
//

import Foundation
import UIKit

final class TrackersCollectionViewCell: UICollectionViewCell {
    let habitCardColorLabel: UILabel = UILabel()
    var emojiLabel: UILabel = UILabel()
    var emojiImage: UIImageView = UIImageView()
    var habitNameLabel: UILabel = UILabel()
    var addDayButton: UIButton = UIButton()
    let dayLabel: UILabel = UILabel()
    
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
    
    private func createEmojiLabel() {
        emojiLabel.layer.backgroundColor = UIColor(named: "EmojiBack")?.cgColor
        emojiLabel.layer.cornerRadius = 68
        emojiLabel.contentMode = .scaleAspectFit
        emojiLabel.textAlignment = .center
        
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emojiLabel)
        
        emojiLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        emojiLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        emojiLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -131).isActive = true
        emojiLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        emojiLabel.widthAnchor.constraint(equalToConstant: 24).isActive = true
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
        addDayButton.backgroundColor = UIColor(named: "33CF69")
        addDayButton.layer.cornerRadius = 17

        addDayButton.setTitle("+", for: .normal)
        addDayButton.setTitleColor(.white, for: .normal)
        
        addDayButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(addDayButton)
        
        addDayButton.topAnchor.constraint(equalTo: habitCardColorLabel.bottomAnchor, constant: 8).isActive = true
        addDayButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
        addDayButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        addDayButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        addDayButton.widthAnchor.constraint(equalToConstant: 34).isActive = true
        
        addDayButton.addTarget(self, action: #selector(didTapAddDayButton), for: .touchUpInside)
    }
    
    @objc private func didTapAddDayButton() {}
    
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

