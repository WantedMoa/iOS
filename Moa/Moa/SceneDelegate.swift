//
//  SceneDelegate.swift
//  Moa
//
//  Created by won heo on 2021/11/15.
//

import UIKit

import Kingfisher

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        let tokenManager = TokenManager()
        tokenManager.jwt = PrivateKey.testToken
        
        if tokenManager.jwt == nil {
            let loginVC = LoginViewController()
            window?.rootViewController = loginVC
        } else {
            let tabVC = MoaTabBarController()
            window?.rootViewController = tabVC
        }

        window?.makeKeyAndVisible()
    }
}

