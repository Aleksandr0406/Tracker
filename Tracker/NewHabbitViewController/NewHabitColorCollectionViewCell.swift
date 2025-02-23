//
//  NewHabitColorCollectionCell.swift
//  Tracker
//
//  Created by 1111 on 13.02.2025.
//

import Foundation
import UIKit

final class NewHabitColorCollectionViewCell: UICollectionViewCell {
    let titleLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
