//
//  AppCoordinator.swift
//  XMovie
//
//  Created by Hamit Seyrek on 31.08.2023.
//

import UIKit

//final class AppCoordinator {
//
//    var window: UIWindow?
//
//    private lazy var homeCoordinator = HomeCoordinator(navigationController: UINavigationController())
//
//    func start(window: UIWindow?) {
//
//        let viewController = MainTabBarController()
////        let navigationController = UINavigationController(rootViewController: viewController) // after added tabbarcontroller removed this
//        window?.rootViewController = viewController
//        window?.makeKeyAndVisible()
//
////        homeCoordinator.start()
////
////        window?.rootViewController = homeCoordinator.navigationController
////        window?.makeKeyAndVisible()
//
//        self.window = window
//    }
//}

// Define what type of flows can be started from this Coordinator
protocol AppCoordinatorProtocol: Coordinator {
    func showLoginFlow()
    func showMainFlow()
}

// App coordinator is the only one coordinator which will exist during app's life cycle
class AppCoordinator: AppCoordinatorProtocol {
    
    weak var finishDelegate: CoordinatorFinishDelegate? = nil
    
    var navigationController: UINavigationController
    
    var childCoordinators = [Coordinator]()
    
    var type: CoordinatorType { .app }
        
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: true)
    }

    func start() {
        showLoginFlow()
    }
        
    func showLoginFlow() {
        // Implementation of Login FLow
        let loginCoordinator = LoginCoordinator.init(navigationController)
        loginCoordinator.finishDelegate = self
        loginCoordinator.start()
        childCoordinators.append(loginCoordinator)
    }

    func showMainFlow() {
        // Implementation Main (Tab bar) FLow
        let tabCoordinator = TabCoordinator.init(navigationController)
        tabCoordinator.finishDelegate = self
        tabCoordinator.start()
        childCoordinators.append(tabCoordinator)
    }
}


extension AppCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })

        switch childCoordinator.type {
        case .tab:
            navigationController.viewControllers.removeAll()

            showLoginFlow()
        case .login:
            navigationController.viewControllers.removeAll()

            showMainFlow()
        default:
            break
        }
    }
}
