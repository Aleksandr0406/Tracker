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
        trackersViewController.tabBarItem = UITabBarItem(title: localizableStrings.titleTrackers, image: UIImage(resource: .tabTrackers), selectedImage: nil)
        
        let statisticsViewController = UINavigationController(rootViewController: StatisticsViewController())
        statisticsViewController.tabBarItem = UITabBarItem(title: localizableStrings.titleStatistics, image: UIImage(resource: .tabStatistics), selectedImage: nil)
        
        self.setViewControllers([trackersViewController, statisticsViewController], animated: true)
    }
}
