//
//  Movies.swift
//  XMovie
//
//  Created by Hamit Seyrek on 26.08.2023.
//

struct Movies: Codable {

    var search: [Movie]?

    var totalResults: String?
    var response: String?

    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
    }
}
