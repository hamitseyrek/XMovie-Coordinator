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

protocol HomeViewModelDelegate: BaseViewModelDelegate {
    func getDataForTableView(movies: [Movie])
    func getDataForCollectionView(movies: [Movie])
    func changeHUDForCV()
}
