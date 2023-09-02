//
//  NetworkManager.swift
//  XMovie
//
//  Created by Hamit Seyrek on 1.09.2023.
//

import Foundation
import UIKit
import Moya

protocol Networkable {
    var provider: MoyaProvider<MovieServiceWithMoya> { get }

    func fetchMovieDetail(movieId: String, completion: @escaping (Result<Movie, Error>) -> ())
    func fetchMovies(searchKey: String, page: Int?, completion: @escaping (Result<Movies, Error>) -> ())
    func fetchMoviePoster(posterUrl: URL, completion: @escaping (Result<UIImage, Error>) -> ())
}

class MoyaNetworkManager: Networkable {
    
    func fetchMoviePoster(posterUrl: URL, completion: @escaping (Result<UIImage, Error>) -> ()) {
//        request(target: .loadPoster(posterPath: posterPath), completion: completion)
        requestImage(target: .loadPoster(posterUrl: posterUrl), completion: completion)
    }
    

    
    var provider = MoyaProvider<MovieServiceWithMoya>(plugins: [NetworkLoggerPlugin()])
    
    func fetchMovies(searchKey : String, page: Int?, completion: @escaping (Result<Movies, Error>) -> ()) {
        
        request(target: .getMovies(searchKey: searchKey, page: page)) { (result: Result<Movies, Error>) in
            
            switch result {
                
            case .success(let moviesResult):
                
                let group = DispatchGroup()
                var movies = moviesResult
                
                for i in 0..<(movies.search?.count ?? 0) {
                    
                    guard let path = movies.search?[i].posterPath, let pathURL = URL(string: path), path.count > 5 else { return }
                    
                    group.enter()
                    self.fetchMoviePoster(posterUrl: pathURL) { (result: Result<UIImage, Error>) in
                        switch result {
                        case .success(let image):
                            movies.search?[i].posterImage = image
                            group.leave()
                        default:
                            group.leave()
                        }
                    }
                }
                
                group.notify(queue: .main) {
                    completion(.success(movies))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchMovieDetail(movieId: String, completion: @escaping (Result<Movie, Error>) -> ()) {
        
            print("******** moya  4 0 ",movieId)
        request(target: .getMovieDetail(movieId: movieId)) { (result: Result<Movie, Error>) in
            
            switch result {
                
            case .success(let movieResult):
                
                let group = DispatchGroup()
                var movie = movieResult
                
                    
                    guard let path = movie.posterPath, let pathURL = URL(string: path), path.count > 5 else {
                        print("******** moya  4 1",movie.posterPath)
                        return }
                    
                    group.enter()
                DispatchQueue.main.async {
                    self.fetchMoviePoster(posterUrl: pathURL) { (result: Result<UIImage, Error>) in
                        switch result {
                        case .success(let image):
                            print("******** moya  4 2", path)
                            movie.posterImage = image
                            group.leave()
                        default:
                            print("******** moya  4 3")
                            group.leave()
                        }
                    }
                }
                
                group.notify(queue: .main) {
                    completion(.success(movie))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }

    }
}

private extension MoyaNetworkManager {
    
    private func request<T: Decodable>(target: MovieServiceWithMoya, completion: @escaping (Result<T, Error>) -> ()) {
        print("******** moya  6 ", target.baseURL, target.path, target.task)
        provider.request(target) { result in
            
            switch result {
                
            case let .success(response):
                
                do {
                    let results = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(results))
                } catch let error {
                    completion(.failure(error))
                }
                
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func requestImage(target: MovieServiceWithMoya, completion: @escaping (Result<UIImage, Error>) -> ()) {
        print("******** moya  4 ", target.baseURL, target.path, target.task)
        provider.request(target) { result in
            
            switch result {
                
            case let .success(response):
                
                if let image = UIImage(data: response.data) {
                    completion(.success(image))
                    
                } else {
                    let underlyingError = NSError(domain: "com.yourAppDomain", code: 400, userInfo: [NSLocalizedDescriptionKey: "Image decoding failed"])
                    completion(.failure(underlyingError))
                }
                
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
