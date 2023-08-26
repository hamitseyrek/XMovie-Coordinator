//
//  MovieServices.swift
//  XMovie
//
//  Created by Hamit Seyrek on 26.08.2023.
//

import Foundation
import UIKit

protocol MovieServiceProtocol {
    func getMovies(searchKey: String, page: Int?, completion: @escaping (Result<Movies, NetworkError >) -> Void)
}

struct MovieService: MovieServiceProtocol {
    
    func getMovies(searchKey: String, page: Int? = nil, completion: @escaping (Result<Movies, NetworkError>) -> Void) {
        
        let search = searchKey
        let page = page ?? 1
        
        let path = "\(Constants.omdbUrl.rawValue)?apikey=\(Constants.apiKey.rawValue)&s=\(search)&page=\(page)"
        
        NetworkRequest.networkRequest(path: path, completion: { response in
            
            switch response {
            case .success(var movies):
                
                let group = DispatchGroup()
                
                for i in 0..<(movies.search?.count ?? 0) {
                    group.enter()
                    DispatchQueue.main.async {
                        self.loadPosters(movie: movies.search?[i], completion: { image in
                            movies.search?[i].posterImage = image
                            group.leave()
                        })
                    }
                }

                group.notify(queue: .main) {
                    completion(.success(movies))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }, value: Movies.self)
    }
    
    private func loadPosters(movie: Movie?, completion: @escaping (UIImage?) -> Void) {
        
        guard let poster = movie?.posterPath, let url = URL(string: "\(poster)") else { return completion(nil) }
        
        let session = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, _ in
            
            guard let data = data, let image = UIImage(data: data) else { return completion(nil) }
            
            completion(image)
        }
        session.resume()
    }
}
