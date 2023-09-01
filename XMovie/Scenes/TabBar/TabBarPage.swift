//
//  MainTabBarController.swift
//  XMovie
//
//  Created by Hamit Seyrek on 28.08.2023.
//

import UIKit

enum TabBarPage {
    case home
    case other
    case other1
    case other2
    case user

    init?(index: Int) {
        switch index {
        case 0:
            self = .home
        case 1:
            self = .other
        case 2:
            self = .other1
        case 3:
            self = .other2
        case 4:
            self = .user
        default:
            return nil
        }
    }
    
    func pageTitleValue() -> String {
        switch self {
        case .home:
            return "Home"
        case .other:
            return "Other"
        case .other1:
            return "Other1"
        case .other2:
            return "Other2"
        case .user:
            return "User"
        }
    }

    func pageOrderNumber() -> Int {
        switch self {
        case .home:
            return 0
        case .other:
            return 1
        case .other1:
            return 2
        case .other2:
            return 3
        case .user:
            return 4
        }
    }

    func pageTabIcon() -> String {
        switch self {
        case .home:
            return "house"
        case .other:
            return "circle.hexagonpath"
        case .other1:
            return "circle.hexagonpath"
        case .other2:
            return "circle.hexagonpath"
        case .user:
            return "person"
        }
    }
    // Add tab icon value
    
    

//    func pageTabIconColor() -> String {
//        switch self {
//        case .home:
//            return "house"
//        case .other:
//            return "circle.hexagonpath"
//        case .other1:
//            return "circle.hexagonpath"
//        case .other2:
//            return "circle.hexagonpath"
//        case .user:
//            return "person"
//        }
//    }
    // Add tab icon selected / deselected color
    
    // etc
}

//enum TabBarItemImages: String {
//    case home = "house"
//    case other = "circle.hexagonpath"
//    case user = "person"
//}
//
//enum TabBarItem: Int {
//    case home
//    case other
//    case other1
//    case other2
//    case user
//}
//
//class TabBarPage: UITabBarController {
//
//    var homeNavigationController: UINavigationController!
//    var otherNavigationController: UINavigationController!
//    var other1NavigationController: UINavigationController!
//    var other2NavigationController: UINavigationController!
//    var userNavigationController: UINavigationController!
//
//    var homeViewController: HomeViewController!
//    var otherViewController: HomeViewController!
//    var other1ViewController: HomeViewController!
//    var other2ViewController: HomeViewController!
//    var userViewController: UserViewController!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.setup()
//    }
//
//    @objc func didTapRightButton() {
//        // Butona tıklandığında yapılacak işlemler
//    }
//
//    func setup() {
//
//        self.navigationController?.navigationBar.isHidden = true
//        self.homeViewController = HomeViewController()
//        self.homeViewController.viewModel = HomeViewModel(service: app.service)
////        let vm = HomeViewModel(service: service)
////        let vc = HomeViewController()
////        vc.viewModel = vm
//
//        self.otherViewController = HomeViewController()
//        self.otherViewController.viewModel = HomeViewModel(service: app.service)
//
//        self.other1ViewController = HomeViewController()
//        self.other1ViewController.viewModel = HomeViewModel(service: app.service)
//
//        self.other2ViewController = HomeViewController()
//        self.other2ViewController.viewModel = HomeViewModel(service: app.service)
//
//        self.userViewController = UserViewController()
//        self.userViewController.title = "User"
//
//        // Her bir view controller'ı bir UINavigationController içerisine koy.
//        self.homeNavigationController = UINavigationController(rootViewController: self.homeViewController)
//        self.otherNavigationController = UINavigationController(rootViewController: self.otherViewController)
//        self.other1NavigationController = UINavigationController(rootViewController: self.other1ViewController)
//        self.other2NavigationController = UINavigationController(rootViewController: self.other2ViewController)
//        self.userNavigationController = UINavigationController(rootViewController: self.userViewController)
//
//        viewControllers = [self.homeNavigationController,
//                           self.otherNavigationController,
//                           self.other1NavigationController,
//                           self.other2NavigationController,
//                           self.userNavigationController]
//
//
//        self.configureIcons(tabNo: 0, imageSystemName: TabBarItemImages.home.rawValue, title: "Home")
//        self.configureIcons(tabNo: 1, imageSystemName: TabBarItemImages.other.rawValue, title: "Other")
//        self.configureIcons(tabNo: 2, imageSystemName: TabBarItemImages.other.rawValue, title: "Other")
//        self.configureIcons(tabNo: 3, imageSystemName: TabBarItemImages.other.rawValue, title: "Other")
//        self.configureIcons(tabNo: 4, imageSystemName: TabBarItemImages.user.rawValue, title: "User")
//
//
//
//        if #available(iOS 15.0, *) {
//           let appearance = UITabBarAppearance()
//           appearance.configureWithOpaqueBackground()
//
//           self.tabBar.standardAppearance = appearance
//           self.tabBar.scrollEdgeAppearance = tabBar.standardAppearance
//        }
//    }
//
//    func topViewController() -> BaseViewController {
//        return (self.selectedViewController as! UINavigationController).topViewController as! BaseViewController
//    }
//
//    private func configureIcons(tabNo: Int, imageSystemName: String, title: String) {
//        self.tabBar.items?[tabNo].image = UIImage(systemName: imageSystemName)?.withTintColor(.gray).withRenderingMode(.alwaysOriginal).withConfiguration(UIImage.SymbolConfiguration(scale: .medium))
//        self.tabBar.items?[tabNo].selectedImage = UIImage(systemName: imageSystemName)?.withTintColor(.blue).withRenderingMode(.alwaysOriginal).withConfiguration(UIImage.SymbolConfiguration(scale: .medium))
//        self.tabBar.items?[tabNo].title = title
//    }
//}
