//
//  NewScheduleTableViewCell.swift
//  Tracker
//
//  Created by 1111 on 20.02.2025.
//

import UIKit

final class NewScheduleTableViewCell: UITableViewCell {
    static let cellIdentifier = "Cell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
