//
//  SceneDelegate.swift
//  Spotify
//
//  Created by Muhammet Ali Yahyaoglu on 28.01.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: windowScene)
    // AuthManager.shared.deleteAccessToken
     if AuthManager.shared.isSignedIn{
            window.rootViewController=TabBarViewController()
         
        }
        else{
            let navVC=UINavigationController(rootViewController: WelcomeViewController())
            navVC.navigationBar.prefersLargeTitles=true
            navVC.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
            window.rootViewController = navVC

        }
        window.makeKeyAndVisible()
        self.window=window
        
        
    }
    
}
