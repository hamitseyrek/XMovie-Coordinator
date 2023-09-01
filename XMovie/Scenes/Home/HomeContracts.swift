//
//  HomeContracts.swift
//  XMovie
//
//  Created by Hamit Seyrek on 26.08.2023.
//

import Foundation

protocol HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate? { get set }
    var service: MovieServiceProtocol { get set }
    func load()
    func moreLoadForCollectionView()
    func moreLoadForTableView()
    func searchMovie(searchText: String)
//    func selectMovie(id: String)
}

enum HomeViewModelOutput {
    case setLoading(Bool)
    case getDataForTableView([Movie],String)
    case getDataForCollectionView([Movie],String)
}

//enum HomeViewRoute {
//    case movieDetail(id: String)
//}

protocol HomeViewModelDelegate: AnyObject {
    func handleViewModelOutput(_ output: HomeViewModelOutput)
//    func navigate(to route: HomeViewRoute)
}
