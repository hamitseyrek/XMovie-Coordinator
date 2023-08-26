//
//  HomeViewModel.swift
//  XMovie
//
//  Created by Hamit Seyrek on 26.08.2023.
//

import Foundation

final class HomeViewModel: HomeViewModelProtocol {
    
    weak var delegate: HomeViewModelDelegate?
    private let service: MovieServiceProtocol
    
    private var searchText: String = "Star"
    
    private var moviesCV: [Movie] = []
    private var totalResultCV: Int?
    
    private var moviesTV: [Movie] = []
    private var totalResultTV: Int?
    
    init(service: MovieServiceProtocol) {
        self.service = service
    }
    
    func load() {
        
        notify(.setLoading(true))
        let group = DispatchGroup()
        group.enter()
        service.getMovies(searchKey: searchText, page: nil) { [weak self] result in
            
            guard let self else { return }
            
            switch result {
            case .success(let response):
                self.totalResultTV = Int(response.totalResults ?? "10")
                self.moviesTV = response.search ?? []
                group.leave()
            case .failure(let error):
#if DEBUG
                print(#function,"***** Error1:  ", error.rawValue)
#endif
                group.leave()
            }
        }
        
        group.enter()
        service.getMovies(searchKey: "Comedy", page: nil) { [weak self] result in
            
            guard let self else { return }
            
            switch result {
            case .success(let response):
                self.totalResultCV = Int(response.totalResults ?? "10")
                self.moviesCV = response.search ?? []
                group.leave()
            case .failure(let error):
#if DEBUG
                print(#function,"***** Error2:  ", error.rawValue)
#endif
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.notify(.setLoading(false))
            self.notify(.showMovieList(self.moviesTV,self.moviesCV))
        }
    }
    
    private func notify(_ output: HomeViewModelOutput) {
        delegate?.handleViewModelOutput(output)
    }
}
