//
//  MovieDetailContracts.swift
//  XMovie
//
//  Created by Hamit Seyrek on 26.08.2023.
//

protocol MovieDetailViewModelProtocol {
    var delegate: MovieDetailViewModelDelegate? { get set }
    func load()
}

enum MovieDetailViewModelOutput {
    case updateTitle(String)
    case setLoading(Bool)
    case showDetail(Movie)
    case showError(String)
}

protocol MovieDetailViewModelDelegate: AnyObject {
    func handleViewModelOutput(_ output: MovieDetailViewModelOutput)
}
