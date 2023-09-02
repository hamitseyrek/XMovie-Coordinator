//
//  HomeViewModel.swift
//  XMovie
//
//  Created by Hamit Seyrek on 26.08.2023.
//

import Foundation

final class HomeViewModel: HomeViewModelProtocol {    
    
    weak var delegate: HomeViewModelDelegate?
    var moyaNetworkManager: MoyaNetworkManager
    
    private var searchText: String = "Star"
    
    private var pageCV = 1
    private var moviesCV: [Movie] = []
    private var totalResultCV = 10
    private var errorCV = ""
    
    private var pageTV = 1
    private var moviesTV: [Movie] = []
    private var totalResultTV = 10
    private var errorTV = ""
    
    init(moyaNetworkManager: MoyaNetworkManager) {
        self.moyaNetworkManager = moyaNetworkManager
    }
    
    func load() {
        
        notify(.setLoading(true))
        let group = DispatchGroup()
        group.enter()
        moyaNetworkManager.fetchMovies(searchKey: searchText, page: nil) { [weak self] result in
            
            guard let self else { return }
            
            switch result {
                
            case .success(let response):
                self.totalResultTV = Int(response.totalResults ?? "10") ?? 10
                self.moviesTV = response.search ?? []
                group.leave()
                
            case .failure(let error):
                self.errorTV = error.localizedDescription
                group.leave()
            }
        }
        
        group.enter()
        
        moyaNetworkManager.fetchMovies(searchKey: "Comedy", page: nil) { [weak self] response in
            
            guard let self else { return }
            
            switch response {
                
            case .success(let response):
                self.totalResultCV = Int(response.totalResults ?? "10") ?? 10
                self.moviesCV = response.search ?? []
                
                group.leave()
                
            case .failure(let error):
                self.errorCV = error.localizedDescription
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.notify(.setLoading(false))
            self.notify(.getDataForCollectionView(self.moviesCV,self.errorCV))
            self.notify(.getDataForTableView(self.moviesTV,self.errorTV))
        }
    }
    
    func moreLoadForCollectionView() {
        
        pageCV += 1
        
        if totalResultCV > self.moviesCV.count {
            
            moyaNetworkManager.fetchMovies(searchKey: "Comedy", page: pageCV) { [weak self] result in
                
                guard let self else { return }
                
                switch result {
                    
                case .success(let response):
                    self.moviesCV.append(contentsOf: response.search ?? [])
                    self.totalResultCV = Int(response.totalResults ?? "10") ?? self.moviesCV.count
                    self.notify(.getDataForCollectionView(self.moviesCV,self.errorCV))
                    
                case .failure(let error):
                    self.errorCV = error.localizedDescription
                    self.notify(.getDataForCollectionView(self.moviesCV,self.errorCV))
                }
            }
        } else { self.notify(.setLoading(false))}
    }
    
    func moreLoadForTableView() {
        
        pageTV += 1
        
        if totalResultTV > self.moviesTV.count {
            self.makeRequestForTableView()
        } else {
            self.notify(.setLoading(false))
        }
    }
    
    func searchMovie(searchText: String) {
        
        pageTV = 1
        self.moviesTV = []
        self.searchText = searchText
        
        self.makeRequestForTableView()
    }
    
    private func makeRequestForTableView() {
        
        notify(.setLoading(true))
        moyaNetworkManager.fetchMovies(searchKey: self.searchText, page: pageTV) { [weak self] result in
            
            guard let self else { return }
            self.notify(.setLoading(false))
            
            switch result {
                
            case .success(let response):
                self.moviesTV.append(contentsOf: response.search ?? [])
                self.totalResultTV = Int(response.totalResults ?? "10") ?? self.moviesTV.count
                self.notify(.getDataForTableView(self.moviesTV,self.errorTV))
                
            case .failure(let error):
                self.errorTV = error.localizedDescription
                self.notify(.getDataForTableView(self.moviesTV,self.errorTV))
            }
        }
    }
    
    private func notify(_ output: HomeViewModelOutput) {
        delegate?.handleViewModelOutput(output)
    }
}
