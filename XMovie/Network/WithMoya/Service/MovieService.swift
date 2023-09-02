//
//  MovieService.swift
//  XMovie
//
//  Created by Hamit Seyrek on 1.09.2023.
//

import Foundation
import Moya

enum MovieServiceWithMoya: Any {
    
    case getMovieDetail(movieId: String)
    case getMovies(searchKey: String, page: Int?)
    case loadPoster(posterUrl: URL)
}

extension MovieServiceWithMoya: TargetType {
    
    var baseURL: URL {
        
        switch self {
        case .loadPoster(let posterUrl):
            return posterUrl
        default:
            guard let url = URL(string: Constants.omdbUrl.rawValue) else { fatalError() }
            return url
        }
    }

    var path: String {
        switch self {
        case .getMovieDetail(_):
            return "/" // "&i=\(movieId)"
        case .getMovies:
            return "/"
        case .loadPoster(let posterUrl):
            return posterUrl.absoluteString
        }
    }

    var method: Moya.Method {
        return .get
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .getMovieDetail(let movieId):
            return .requestParameters(parameters: ["apikey": Constants.apiKey.rawValue, "i": movieId], encoding: URLEncoding.queryString)
        case .getMovies(let searchKey, let page):
            let page = page ?? 1
            return .requestParameters(parameters: ["apikey": Constants.apiKey.rawValue, "s": searchKey, "page": page], encoding: URLEncoding.queryString)
        case .loadPoster:
            return .requestPlain
        }
    }

    var headers: [String : String]? {
        return ["Content-type" : "application/json", "User-Agent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X x.y; rv:42.0) Gecko/20100101 Firefox/42.0"]
    }
}

