//
//  TrackersCollectionViewSup.swift
//  Tracker
//
//  Created by 1111 on 24.02.2025.
//

import UIKit

final class TrackersCollectionSupplementaryView: UICollectionReusableView {
    static let headerIdentifier = "Header"
    
    let colorsForDarkLightTheme: ColorsForDarkLightTheme = ColorsForDarkLightTheme()

    let titleLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .left
        titleLabel.font = .boldSystemFont(ofSize: 19)
        titleLabel.textColor = colorsForDarkLightTheme.blackWhiteDLT
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
