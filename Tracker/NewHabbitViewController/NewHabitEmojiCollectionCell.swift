//
//  NewHabitEmojiCollectionCell.swift
//  Tracker
//
//  Created by 1111 on 13.02.2025.
//

import UIKit

final class NewHabitEmojiCollectionCell: UICollectionViewCell {
    static let cellIdentifier = "EmojiCell"
    
    let titleLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 32)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.widthAnchor.constraint(equalToConstant: 32),
            titleLabel.heightAnchor.constraint(equalToConstant: 38)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
