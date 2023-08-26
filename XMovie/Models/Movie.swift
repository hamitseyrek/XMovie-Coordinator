//
//  Movie.swift
//  XMovie
//
//  Created by Hamit Seyrek on 26.08.2023.
//

import UIKit

struct Movie: Codable {
    
    let title: String?
    let id: String
    let posterPath: String?
    let movieType: String?
    let year: String?
    var posterImage: UIImage?
    let actors: String?
    let plot: String?
    
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case id = "imdbID"
        case posterPath = "Poster"
        case movieType = "Type"
        case year = "Year"
        case actors = "Actor"
        case plot = "Plot"
    }
}
