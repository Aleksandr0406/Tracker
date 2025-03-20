//
//  Helper.swift
//  Tracker
//
//  Created by 1111 on 20.03.2025.
//

import Foundation

final class OnBoardingData {
    static var isThisNotFirstLoad: Bool {
        get { UserDefaults.standard.bool(forKey: "IsThisNotFirstLoad") }
        set { UserDefaults.standard.set(newValue, forKey: "IsThisNotFirstLoad") }
    }
}
