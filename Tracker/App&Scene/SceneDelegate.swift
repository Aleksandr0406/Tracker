//
//  SceneDelegate.swift
//  Tracker
//
//  Created by 1111 on 30.01.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        window.rootViewController = TabBarController()
        self.window = window
        self.window?.makeKeyAndVisible()
    }
}

