//
//  SceneDelegate.swift
//  BitmexClone
//
//  Created by 경원이 on 2023/09/30.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let rootViewController = TradingViewController()
        window.rootViewController = rootViewController
        
        self.window = window
        window.makeKeyAndVisible()
    }

}

