//
//  AppBuilder.swift
//  XMovie
//
//  Created by Hamit Seyrek on 26.08.2023.
//

import Foundation
import UIKit

final class AppBuilder {
    
    static func makeHome() -> HomeViewController {
        
        let viewController = HomeViewController()
        viewController.viewModel = HomeViewModel(service: app.service)
        return viewController
    }
}
