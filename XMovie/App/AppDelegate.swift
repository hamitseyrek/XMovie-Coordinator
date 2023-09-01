//
//  AppDelegate.swift
//  XMovie
//
//  Created by Hamit Seyrek on 26.08.2023.
//

import UIKit

@main
//class AppDelegate: UIResponder, UIApplicationDelegate {
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        // Override point for customization after application launch.
//        app.router.start()
//        return true
//    }
//}

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var appCoordinator: AppCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
            
            let navigationController: UINavigationController = .init()

            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
            
            appCoordinator = AppCoordinator.init(navigationController)
            appCoordinator?.start()
                    
            return true
    }
}

