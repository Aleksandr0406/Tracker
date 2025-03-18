//
//  SceneDelegate.swift
//  Tracker
//
//  Created by 1111 on 30.01.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var isThisNotFirstLoad: Bool {
        get { UserDefaults.standard.bool(forKey: "IsThisNotFirstLoad") }
        set { UserDefaults.standard.set(newValue, forKey: "IsThisNotFirstLoad") }
    }
    
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        let onBoardingViewController = OnBoardingViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        let tabBarController = TabBarController()
        window.rootViewController = isThisNotFirstLoad ? tabBarController : onBoardingViewController
        self.window = window
        self.window?.makeKeyAndVisible()
    }
}

