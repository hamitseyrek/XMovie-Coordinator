//
//  HomeContracts.swift
//  XMovie
//
//  Created by Hamit Seyrek on 26.08.2023.
//

import Foundation

protocol HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate? { get set }
    func load()
    func moreLoadForCollectionView()
    func moreLoadForTableView()
}

enum HomeViewModelOutput {
    case setLoading(Bool)
    case showMovieList([Movie],[Movie])
    case showMoreLoadCollectionMovieList([Movie])
    case showMoreLoadTableMovieList([Movie])
}

protocol HomeViewModelDelegate: AnyObject {
    func handleViewModelOutput(_ output: HomeViewModelOutput)
}
