//
//  NetworkRequest.swift
//  XMovie
//
//  Created by Hamit Seyrek on 26.08.2023.
//

import Foundation

enum NetworkRequest {
    
    static func networkRequest<T: Decodable>(path: String, completion: @escaping (Result<T,NetworkError>) -> Void, value: T.Type) {
        
        guard let url = URL(string: path) else { return completion(.failure(.invalidEndpoint)) }
        
        let session = URLSession.shared.dataTask(with: url) { data, _, error in
            
            guard error == nil else { return completion(.failure(.requestFailed)) }
            
            guard let data = data, let movies = try? JSONDecoder().decode(T.self, from: data) else { return completion(.failure(.fetchError)) }
            
            completion(.success(movies))
        }
        session.resume()
    }
}
