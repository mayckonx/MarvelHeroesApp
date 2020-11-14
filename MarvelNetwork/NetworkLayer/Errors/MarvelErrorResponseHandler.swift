//
//  MarvelErrorResponseHandler.swift
//  MarvelNetwork
//
//  Created by Mayckon B on 14.11.20.
//

import Moya

/// This class is responsible for parsing the errors coming from the network operations
/// And convert them into presentable/user-friendly errors
struct MarvelErrorResponseHandler {
    
    /// Converts the network operation error into a user-friendly error
    static func parse(from error: MoyaError) -> MarvelErrorResponse {
        switch error {
        case .underlying(let nsError as NSError, _):
           return connectionErrors(from: nsError)
        case .statusCode(let response):
            if 400...500 ~= response.statusCode {
                return .unauthorized
            }
        default:
            return .internalServerError
        }
        
        return .internalServerError
    }
}

// MARK: - Auxiliar Methods

private extension MarvelErrorResponseHandler {
    
    static func connectionErrors(from error: NSError) -> MarvelErrorResponse {
        if error.code == NSURLErrorTimedOut {
            return .connectionTimeout
        } else if error.code == NSURLErrorNotConnectedToInternet {
            return .offline
        }
        
        return .unknown
    }
    
}
