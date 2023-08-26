//
//  AppContainer.swift
//  XMovie
//
//  Created by Hamit Seyrek on 26.08.2023.
//

import Foundation

let app = AppContainer()
let userDefaults = UserDefaults.standard

final class AppContainer {
    
    let router = AppRouter()
    let service = MovieService()
}
