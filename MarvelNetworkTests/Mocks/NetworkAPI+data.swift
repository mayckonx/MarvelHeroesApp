//
//  NetworkAPI+data.swift
//  MarvelNetworkTests
//
//  Created by Mayckon B on 15.11.20.
//

import Foundation

@testable import MarvelNetwork

// MARK: - Stub response data

public extension NetworkAPI {
    
    var responseData: Data {
        switch self {
        case .characters:
            return Bundle.loadResponse(name: "characters-response", target: NetworkServiceTests.self)!
        case .character:
            return Bundle.loadResponse(name: "character", target: NetworkServiceTests.self)!
        }
    }
    
    var brokenResponseData: Data {
        switch self {
        case .characters:
            return Bundle.loadResponse(name: "characters-response-broken", target: NetworkServiceTests.self)!
        case .character:
            return Bundle.loadResponse(name: "character", target: NetworkServiceTests.self)!
        }
    }
    
}
