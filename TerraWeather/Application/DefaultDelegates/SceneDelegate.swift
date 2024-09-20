//
//  SceneDelegate.swift
//  TerraWeather
//
//  Created by Ega Setya Putra on 19/09/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: MainCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else { return }
                
        let navigationController = UINavigationController()
        coordinator = DefaultMainCoordinator(navigationController: navigationController)
        coordinator?.start()
        self.window = UIWindow.init(windowScene: scene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

