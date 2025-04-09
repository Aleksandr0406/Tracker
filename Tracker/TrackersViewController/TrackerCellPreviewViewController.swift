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
    
    let emojiLabel: UILabel = UILabel()
    let emojiBackLabel: UILabel = UILabel()
    let habitNameLabel: UILabel = UILabel()
    
    init(colorBack: CGColor, emoji: String, habitName: String) {
        
        self.colorBack = colorBack
        self.emoji = emoji
        self.habitName = habitName
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.backgroundColor = colorBack
        preferredContentSize = CGSize(width: 167, height: 90)
        
        createEmojiLabel()
        createEmojiBackLabel()
        createHabitNameLabel()
        setConstraints()
    }
    
    private func createEmojiBackLabel() {
        emojiBackLabel.layer.backgroundColor = UIColor(named: "EmojiBack")?.cgColor
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
            emojiLabel.bottomAnchor.constraint(equalTo: emojiBackLabel.bottomAnchor, constant: -1)
        ])
    }
}
