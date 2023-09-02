//
//  HomeContracts.swift
//  XMovie
//
//  Created by Hamit Seyrek on 26.08.2023.
//

import Foundation

protocol HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate? { get set }
    var moyaNetworkManager: MoyaNetworkManager { get set }
    func load()
    func moreLoadForCollectionView()
    func moreLoadForTableView()
    func searchMovie(searchText: String)
}

enum HomeViewModelOutput {
    case setLoading(Bool)
    case getDataForTableView([Movie],String)
    case getDataForCollectionView([Movie],String)
}

protocol HomeViewModelDelegate: AnyObject {
    func handleViewModelOutput(_ output: HomeViewModelOutput)
}
