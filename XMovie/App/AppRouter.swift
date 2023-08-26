//
//  AppRouter.swift
//  XMovie
//
//  Created by Hamit Seyrek on 26.08.2023.
//

import Foundation
import UIKit

final class AppRouter {
    
    let window: UIWindow
    
    init() {
        window = UIWindow(frame: UIScreen.main.bounds)
    }
    
    func start() {
        
        let viewController = AppBuilder.makeHome()
        let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
    }
}
