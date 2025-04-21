//
//  AppDelegate.swift
//  Tracker
//
//  Created by 1111 on 30.01.2025.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AnalyticsService.activate()
        TrackerScheduleValueTransformer.register()
        return true
    }
}


