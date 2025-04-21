//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by 1111 on 27.03.2025.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {

    func testMainScreen() {
        let vc = TabBarController()
        
        assertSnapshot(of: vc, as: .image)
    }
}
