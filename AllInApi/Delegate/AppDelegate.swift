//
//  AppDelegate.swift
//  AllInApi
//
//  Created by Archisman on 01/08/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // Called when the app has finished launching.
    // Good place to configure third-party libraries or initial app settings.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    // Called when a new scene (UI window) is being created.
    // You can configure and return a UISceneConfiguration to define how the new scene should be set up.
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    // Called when a scene session is discarded.
    // Clean up resources that were specific to the discarded scenes here.
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
