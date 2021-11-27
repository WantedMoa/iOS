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
        
        tokenManager.jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWR4IjoyLCJpYXQiOjE2Mzc4MzIxNDgsImV4cCI6MTY2OTM2ODE0OCwic3ViIjoidXNlckluZm8ifQ.YZQ4bqRATOluBv9Sa-0JyXnTY5MZgWRI-Rk3jn4d2LU"
        
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

