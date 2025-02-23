//
//  NewHabitEmojiCollectionCell.swift
//  Tracker
//
//  Created by 1111 on 13.02.2025.
//

import Foundation
import UIKit

final class NewHabitEmojiCollectionViewCell: UICollectionViewCell {
    let titleLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 32)
        
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 32).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 38).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
