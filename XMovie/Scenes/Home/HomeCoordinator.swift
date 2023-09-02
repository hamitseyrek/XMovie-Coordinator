//
//  HomeCoordinator.swift
//  XMovie
//
//  Created by Hamit Seyrek on 31.08.2023.
//

import UIKit

protocol HomeCoordinatorProtocol: Coordinator {
    func showHomeViewController()
    func showDetailViewController(moyaNetworkManager: MoyaNetworkManager, id: String)
}

final class HomeCoordinator: HomeCoordinatorProtocol {
    
    var childCoordinators: [Coordinator] = []
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var type: CoordinatorType { .tab }
    
    var navigationController: UINavigationController
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showHomeViewController()
    }
    
    func showHomeViewController() {
        
        let moyaNetworkManager = MoyaNetworkManager()
        let vm = HomeViewModel(moyaNetworkManager: moyaNetworkManager)
        let vc = HomeViewController()
        vc.viewModel = vm
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showDetailViewController(moyaNetworkManager: MoyaNetworkManager, id: String) {
        
        print("***** look at me ")
        let vc = MovieDetailViewController()
        vc.viewModel = MovieDetailViewModel(id: id, moyaNetworkManager: moyaNetworkManager)
        navigationController.pushViewController(vc, animated: true)
    }
}
