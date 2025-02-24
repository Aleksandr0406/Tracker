//
//  NewHabitHeaderView.swift
//  Tracker
//
//  Created by 1111 on 13.02.2025.
//

import Foundation
import UIKit

final class NewHabitCollectionSupplementaryView: UICollectionReusableView {
    static let headerIdentifier = "Header"
    
    let titleLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .left
        titleLabel.font = .boldSystemFont(ofSize: 19)
        
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
