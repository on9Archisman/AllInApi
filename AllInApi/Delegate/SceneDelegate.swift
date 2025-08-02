//
//  SceneDelegate.swift
//  AllInApi
//
//  Created by Archisman on 01/08/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        NetworkMonitor.shared.startMonitoring()
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        if JailBreakDetector.isJailbroken() {
            makeJailBreakWarningViewController()
        } else {
            makeUserListViewController()
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }
}

extension SceneDelegate {
    private func makeJailBreakWarningViewController() {
        let warningVC = WarningViewController()
        warningVC.title = "All In Api"
        let navVC = UINavigationController(rootViewController: warningVC)
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
    }
    
    private func makeUserListViewController() {
        let userListVC = UserListViewController()
        userListVC.title = "All In Api"
        let networkClient = NetworkClient()
        let userListResource = UserListResource(networkClient: networkClient)
        let userlistViewModel = UserListViewModel(userListResource: userListResource)
        userListVC.viewModel = userlistViewModel
        let navVC = UINavigationController(rootViewController: userListVC)
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
    }
}
