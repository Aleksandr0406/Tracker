//
//  TabBarController.swift
//  Tracker
//
//  Created by 1111 on 30.01.2025.
//

import UIKit

final class TabBarController: UITabBarController  {
    private let localizableStrings: LocalizableStringsTabBarC = LocalizableStringsTabBarC()
    override func viewDidLoad() {
        let trackersViewController = UINavigationController(rootViewController: TrackersViewController())
        trackersViewController.tabBarItem = UITabBarItem(title: localizableStrings.titleTrackers, image: UIImage(named: "Tab_trackers"), selectedImage: nil)
        
        let statisticsViewController = UINavigationController(rootViewController: StatisticsViewController())
        statisticsViewController.tabBarItem = UITabBarItem(title: localizableStrings.titleStatistics, image: UIImage(named: "Tab_statistics"), selectedImage: nil)
        
        self.setViewControllers([trackersViewController, statisticsViewController], animated: true)
    }
}
