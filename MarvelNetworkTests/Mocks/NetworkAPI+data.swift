//
//  NetworkAPI+data.swift
//  MarvelNetworkTests
//
//  Created by Mayckon B on 15.11.20.
//

import Foundation

@testable import MarvelNetwork

// MARK: - Stub response data

extension NetworkAPI {
    
    var responseData: Data {
        switch self {
        case .characters:
            return Bundle.loadResponse(name: "characters-response")!
        case .character:
            return Bundle.loadResponse(name: "character")!
        }
    }
    
    var brokenResponseData: Data {
        switch self {
        case .characters:
            return Bundle.loadResponse(name: "characters-response-broken")!
        case .character:
            return Bundle.loadResponse(name: "character")!
        }
    }
    
}
