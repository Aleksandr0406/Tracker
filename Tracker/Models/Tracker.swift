//
//  Tracker.swift
//  Tracker
//
//  Created by 1111 on 04.02.2025.
//

import UIKit

struct Tracker: Codable {
    let id: UUID
    let name: String
    let color: String
    let emoji: String
    let schedule: [Int]
}
