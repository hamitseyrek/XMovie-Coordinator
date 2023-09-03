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
        
        self.delegate?.showHUD()
        
        moyaNetworkManager.fetchMovieDetail(movieId: id) { [weak self] result in
            
            self?.delegate?.hideHUD()
            
            switch result {
                
            case .success(let movie):
                self?.delegate?.showDetail(movie: movie)
                
            case .failure(let error):
                self?.delegate?.showError(errorString: error.localizedDescription)
            }
        }
    }
}
