//
//  MovieDetailViewModel.swift
//  XMovie
//
//  Created by Hamit Seyrek on 26.08.2023.
//

import Foundation

final class MovieDetailViewModel: MovieDetailViewModelProtocol {
    
    weak var delegate: MovieDetailViewModelDelegate?
    private let moyaNetworkManager: MoyaNetworkManager
    private let id: String?
    
    init(id: String, moyaNetworkManager: MoyaNetworkManager) {
        self.moyaNetworkManager = moyaNetworkManager
        self.id = id
    }
    
    func load() {
        
        guard let id else { return }
        
        notify(.setLoading(true))
        
        moyaNetworkManager.fetchMovieDetail(movieId: id) { [weak self] result in
            
            self?.notify(.setLoading(false))
            
            switch result {
                
            case .success(let movie):
                self?.notify(.showDetail(movie))
                self?.notify(.updateTitle(movie.title ?? "Movie Detail"))
                
            case .failure(let error):
                self?.notify(.showError(error.localizedDescription))
            }
        }
    }
    
    private func notify(_ output: MovieDetailViewModelOutput) {
        delegate?.handleViewModelOutput(output)
    }
}
