//
//  TrackerCellPreviewViewController.swift
//  Tracker
//
//  Created by 1111 on 31.03.2025.
//

import UIKit

final class TrackerCellPreviewViewController: UIViewController {
    let colorBack: CGColor
    let emoji: String
    let habitName: String
    let isPinned: Bool
    
    let emojiLabel: UILabel = UILabel()
    let emojiBackLabel: UILabel = UILabel()
    let habitNameLabel: UILabel = UILabel()
    let pinImage: UIImageView = UIImageView()
    
    init(colorBack: CGColor, emoji: String, habitName: String, isPinned: Bool) {
        
        self.colorBack = colorBack
        self.emoji = emoji
        self.habitName = habitName
        self.isPinned = isPinned
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.backgroundColor = colorBack
        preferredContentSize = CGSize(width: 167, height: 90)
        
        createEmojiLabel()
        createEmojiBackLabel()
        createHabitNameLabel()
        createPinImage()
        setConstraints()
    }
    
    private func createEmojiBackLabel() {
        emojiBackLabel.layer.backgroundColor = UIColor(resource: .emojiBack).cgColor
        emojiBackLabel.layer.cornerRadius = 12
        
        emojiBackLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emojiBackLabel)
    }
    
    private func createEmojiLabel() {
        emojiLabel.text = emoji
        emojiLabel.font = .systemFont(ofSize: 16)
        emojiLabel.textAlignment = .center
        emojiLabel.adjustsFontSizeToFitWidth = true
        
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emojiLabel)
    }
    
    private func createHabitNameLabel() {
        habitNameLabel.text = habitName
        habitNameLabel.adjustsFontSizeToFitWidth = true
        habitNameLabel.textAlignment = .left
        habitNameLabel.font = .systemFont(ofSize: 12)
        habitNameLabel.textColor = .white
        habitNameLabel.numberOfLines = 2
        
        habitNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(habitNameLabel)
    }
    
    private func createPinImage() {
        pinImage.image = UIImage(resource: .pin)
        
        pinImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pinImage)
        
        pinImage.isHidden = !isPinned
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            habitNameLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12),
            habitNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            habitNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            
            emojiBackLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            emojiBackLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -131),
            emojiBackLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -54),
            emojiBackLabel.heightAnchor.constraint(equalToConstant: 24),
            emojiBackLabel.widthAnchor.constraint(equalToConstant: 24),
            
            emojiLabel.topAnchor.constraint(equalTo: emojiBackLabel.topAnchor, constant: 1),
            emojiLabel.leadingAnchor.constraint(equalTo: emojiBackLabel.leadingAnchor, constant: 4),
            emojiLabel.trailingAnchor.constraint(equalTo: emojiBackLabel.trailingAnchor, constant: -4),
            emojiLabel.bottomAnchor.constraint(equalTo: emojiBackLabel.bottomAnchor, constant: -1),
            
            pinImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            pinImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            pinImage.heightAnchor.constraint(equalToConstant: 24),
            pinImage.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
}
