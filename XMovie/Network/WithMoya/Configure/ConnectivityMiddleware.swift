//
//  ConnectivityMiddleware.swift
//  XMovie
//
//  Created by Hamit Seyrek on 1.09.2023.
//

import Foundation
import Alamofire

protocol ConnectivityMiddleware {
    func checkForInternetConnection(_ completion: @escaping (Bool) -> Void)
}


extension ConnectivityMiddleware {
    func checkForInternetConnection(_ completion: @escaping (Bool) -> Void) {
        completion(NetworkReachabilityManager()?.isReachable ?? false)
    }
}
