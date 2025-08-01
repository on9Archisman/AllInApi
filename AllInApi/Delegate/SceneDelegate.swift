//
//  SceneDelegate.swift
//  AllInApi
//
//  Created by Archisman on 01/08/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    // Called when the scene is being connected to the app session
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        // Start monitoring network status
        NetworkMonitor.shared.startMonitoring()
        
        // Ensure the scene is a valid UIWindowScene
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Create a UIWindow for the given scene
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        // Decide which initial view controller to display based on jailbreak detection
        if JailBreakDetector.isJailbroken() {
            makeJailBreakWarningViewController()
        } else {
            makeUserListViewController()
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Scene was released by the system. Clean up resources here if needed.
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Scene moved from inactive to active state. Resume tasks if needed.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Scene will move from active to inactive. Useful for temporary interruptions.
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Scene is transitioning from background to foreground. Undo background changes here.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Scene transitioned to background. Save state and release resources here.
    }
}

extension SceneDelegate {
    
    // Setup the view controller shown when the device is detected as jailbroken
    private func makeJailBreakWarningViewController() {
        let warningVC = WarningViewController()
        warningVC.title = "All In Api"
        let navVC = UINavigationController(rootViewController: warningVC)
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
    }
    
    // Setup the normal user list view controller if the device is safe
    private func makeUserListViewController() {
        let userListVC = UserListViewController()
        userListVC.title = "All In Api"
        
        // Inject dependencies: network client → resource → view model
        let networkClient = NetworkClient()
        let userListResource = UserListResource(networkClient: networkClient)
        let userlistViewModel = UserListViewModel(userListResource: userListResource)
        userListVC.viewModel = userlistViewModel
        
        let navVC = UINavigationController(rootViewController: userListVC)
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
    }
}
