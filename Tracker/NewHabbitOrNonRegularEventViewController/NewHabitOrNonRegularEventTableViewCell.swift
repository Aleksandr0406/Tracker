//
//  NewHabbitCell.swift
//  Tracker
//
//  Created by 1111 on 11.02.2025.
//

import UIKit

final class NewHabitOrNonRegularEventTableViewCell: UITableViewCell {
    static let cellIdentifier = "HabitCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
