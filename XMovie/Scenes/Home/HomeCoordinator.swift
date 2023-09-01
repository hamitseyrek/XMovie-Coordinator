//
//  HomeCoordinator.swift
//  XMovie
//
//  Created by Hamit Seyrek on 31.08.2023.
//

import UIKit

protocol HomeCoordinatorProtocol: Coordinator {
    func showHomeViewController()
    func showDetailViewController(service: MovieServiceProtocol, id: String)
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
        
        let service = MovieService()
        let vm = HomeViewModel(service: service)
        let vc = HomeViewController()
        vc.viewModel = vm
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showDetailViewController(service: MovieServiceProtocol, id: String) {
        
        print("***** look at me ")
        let vc = MovieDetailViewController()
        vc.viewModel = MovieDetailViewModel(service: service, id: id)
        navigationController.pushViewController(vc, animated: true)
    }
}
