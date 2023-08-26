//
//  NetworkError.swift
//  XMovie
//
//  Created by Hamit Seyrek on 26.08.2023.
//

import Foundation

enum NetworkError: String, Error {
    
    case fetchError = "Failed to fetch data"
    case invalidEndpoint = "Invalid endpoint"
    case serializationError = "Failed to decode data"
    case notExist = "Data not exist"
    case requestFailed = "Request Failed"
}
