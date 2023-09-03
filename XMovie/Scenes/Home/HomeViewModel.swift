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
        
        self.delegate?.showHUD()
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
            self.delegate?.hideHUD()
            self.delegate?.getDataForCollectionView(movies: self.moviesCV)
            self.delegate?.getDataForTableView(movies: self.moviesTV)
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
                    self.delegate?.getDataForCollectionView(movies: self.moviesCV)
                    
                case .failure(let error):
                    
                    self.pageCV -= 1
                    self.delegate?.showError(error)
                    self.delegate?.changeHUDForCV()
                }
            }
        } else {
            self.delegate?.hideHUD()
        }
    }
    
    func moreLoadForTableView() {
        
        if totalResultTV > self.moviesTV.count {
            pageTV += 1
            self.makeRequestForTableView()
        } else {
            self.delegate?.hideHUD()
        }
    }
    
    func searchMovie(searchText: String) {
        
        pageTV = 1
        self.moviesTV = []
        self.searchText = searchText
        
        self.makeRequestForTableView()
    }
    
    private func makeRequestForTableView() {
        
        self.delegate?.showHUD()
        moyaNetworkManager.fetchMovies(searchKey: self.searchText, page: pageTV) { [weak self] result in
            
            guard let self else { return }
            self.delegate?.hideHUD()
            
            switch result {
                
            case .success(let response):
                self.moviesTV.append(contentsOf: response.search ?? [])
                self.totalResultTV = Int(response.totalResults ?? "10") ?? self.moviesTV.count
                self.delegate?.getDataForTableView(movies: self.moviesTV)
                
            case .failure(let error):
                
                self.pageCV -= 1
                self.delegate?.showError(error)
            }
        }
    }
}
