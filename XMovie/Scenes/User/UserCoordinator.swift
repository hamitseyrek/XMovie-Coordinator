//
//  UserCoordinator.swift
//  XMovie
//
//  Created by Hamit Seyrek on 31.08.2023.
//

import UIKit

protocol UserCoordinatorProtocol: Coordinator {
    func showUserViewController()
    func showSecondVC()
}

final class UserCoordinator: UserCoordinatorProtocol {
    
    var childCoordinators: [Coordinator] = []
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var type: CoordinatorType { .tab }
    
    var navigationController: UINavigationController
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showUserViewController()
    }
    
    func showUserViewController() {
        
        let vc = UserViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showSecondVC() {
        let vc = SecondVC()
        vc.coordinator = self
//        vc.didSendEventClosure = { [weak self] event in
//            switch event {
//            case .gotoUserCV:
//                self?.showUserViewController()
//            }
//        }
        navigationController.pushViewController(vc, animated: false)
    }
}
