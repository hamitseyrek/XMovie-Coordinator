//
//  TabCoordinator.swift
//  XMovie
//
//  Created by Hamit Seyrek on 31.08.2023.
//

import UIKit

class TabCoordinator: NSObject, Coordinator {
    
    weak var finishDelegate: CoordinatorFinishDelegate?
        
    var childCoordinators: [Coordinator] = []

    var navigationController: UINavigationController
    
    var tabBarController: UITabBarController

    var type: CoordinatorType { .tab }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = .init()
    }

    func start() {
        // Let's define which pages do we want to add into tab bar
        let pages: [TabBarPage] = [.home, .other, .other1, .other2, .user]
            .sorted(by: { $0.pageOrderNumber() < $1.pageOrderNumber() })
        
        // Initialization of ViewControllers or these pages
        let controllers: [UINavigationController] = pages.map({ getTabController($0) })
        
        prepareTabBarController(withTabControllers: controllers)
        
    }
        
    deinit {
        print("TabCoordinator deinit")
    }
    
    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        /// Set delegate for UITabBarController
        tabBarController.delegate = self
        /// Assign page's controllers
        tabBarController.setViewControllers(tabControllers, animated: true)
        /// Let set index
        tabBarController.selectedIndex = TabBarPage.home.pageOrderNumber()
        /// Styling
        ///
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            
            self.tabBarController.tabBar.standardAppearance = appearance
            self.tabBarController.tabBar.scrollEdgeAppearance = tabBarController.tabBar.standardAppearance
        }
        
        tabBarController.tabBar.isTranslucent = false
        
        /// In this step, we attach tabBarController to navigation controller associated with this coordanator
        navigationController.viewControllers = [tabBarController]
    }
    
    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        
        let navController = UINavigationController()
        navController.setNavigationBarHidden(false, animated: false)

        let pageIcon = UIImage(systemName: page.pageTabIcon())?.withRenderingMode(.alwaysOriginal).withConfiguration(UIImage.SymbolConfiguration(scale: .medium))
        navController.tabBarItem = UITabBarItem.init(title: page.pageTitleValue(),
                                                     image: pageIcon?.withTintColor(.gray), selectedImage: pageIcon?.withTintColor(.blue))
        
        switch page {
        case .home:
            
            // If needed: Each tab bar flow can have it's own Coordinator.
            let homeCoordinator = HomeCoordinator.init(navController)
            homeCoordinator.finishDelegate = finishDelegate
            homeCoordinator.start()
            childCoordinators.append(homeCoordinator)
            
        case .other:
            
            let homeCoordinator = HomeCoordinator.init(navController)
            homeCoordinator.finishDelegate = finishDelegate
            homeCoordinator.start()
            childCoordinators.append(homeCoordinator)
                        
        case .user:
            
            // If needed: Each tab bar flow can have it's own Coordinator.
            let userCoordinator = UserCoordinator.init(navController)
            userCoordinator.finishDelegate = finishDelegate
            userCoordinator.start()
            childCoordinators.append(userCoordinator)
            
        default:
            
#if DEBUG
            print(#function,"***** HSTABBAR Empty state ")
#endif
            
        }
        
        return navController
    }
}

// MARK: - UITabBarControllerDelegate
extension TabCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        // Some implementation
    }
}
