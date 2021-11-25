//
//  SceneDelegate.swift
//  Moa
//
//  Created by won heo on 2021/11/15.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let tabVC = MoaTabBarController()
        let testVC = LoginViewController()
        window?.rootViewController = tabVC
        window?.makeKeyAndVisible()
    }
}

