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
    
    private var pageCV = 1
    private var moviesCV: [Movie] = []
    private var totalResultCV = 10
    
    private var pageTV = 1
    private var moviesTV: [Movie] = []
    private var totalResultTV = 10
    
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
                self.totalResultTV = Int(response.totalResults ?? "10") ?? 10
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
                self.totalResultCV = Int(response.totalResults ?? "10") ?? 10
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
    
    func moreLoadForCollectionView() {
        
        pageCV += 1
        
        notify(.setLoading(true))
        if totalResultCV > self.moviesCV.count {
            service.getMovies(searchKey: "Comedy", page: pageCV) { [weak self] result in
                
                guard let self else { return }
                self.notify(.setLoading(false))
                
                switch result {
                case .success(let response):
                    self.moviesCV.append(contentsOf: response.search ?? [])
                    self.totalResultCV = Int(response.totalResults ?? "10") ?? self.moviesCV.count
                    self.notify(.showMoreLoadCollectionMovieList(self.moviesCV))
                case .failure(let error):
#if DEBUG
                print(#function,"***** Error2:  ", error.rawValue)
#endif
                }
            }
        } else { self.notify(.setLoading(false))}
    }
    
    func moreLoadForTableView() {
        
        pageTV += 1
        
        notify(.setLoading(true))
        if totalResultTV > self.moviesTV.count {
            service.getMovies(searchKey: self.searchText, page: pageTV) { [weak self] result in
                
                guard let self else { return }
                self.notify(.setLoading(false))
                
                switch result {
                case .success(let response):
                    self.moviesTV.append(contentsOf: response.search ?? [])
                    self.totalResultTV = Int(response.totalResults ?? "10") ?? self.moviesTV.count
                    self.notify(.showMoreLoadTableMovieList(self.moviesTV))
                case .failure(let error):
#if DEBUG
                print(#function,"***** Error2:  ", error.rawValue)
#endif
                }
            }
        } else { self.notify(.setLoading(false))}
    }
    
    private func notify(_ output: HomeViewModelOutput) {
        delegate?.handleViewModelOutput(output)
    }
}
