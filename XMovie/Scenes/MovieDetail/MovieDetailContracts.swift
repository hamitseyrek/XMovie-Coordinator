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

protocol MovieDetailViewModelDelegate: BaseViewModelDelegate {
    func showDetail(movie: Movie)
    func showError(errorString: String)
}
