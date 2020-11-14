//
//  NetworkAPI.swift
//  MarvelNetwork
//
//  Created by Mayckon B on 14.11.20.
//

import Foundation
import Keys
import Moya
import CommonCrypto

// MARK: - Constants and Endpoints

public enum NetworkAPI {
    
    private enum Constants {
    
        // MARK: -  API Setup
        
        private static let keys = MarvelHeroesKeys()
        static let baseURL = "https://gateway.marvel.com"
        static let privatekey = keys.marvelPrivateKey
        static let apikey = keys.marvelApiKey
        static let timestamp = Date().timeIntervalSince1970.description
        static let hash = "\(timestamp)\(privatekey)\(apikey)".md5
        
        // MARK: - Queries
        static let queryCharactersKey = "nameStartsWith"
        static let queryCharacterKey = "characterId"
    }
    
    // characters
    case characters(_ nameStartsWith: String?)
    case character(_ characterId: String)
    
}

// MARK: - API Config

extension NetworkAPI: TargetType, AccessTokenAuthorizable {
    
    public var headers: [String : String]? {
        return [:]
    }
    
    public var authorizationType: AuthorizationType? {
        return nil
    }
    
    public var baseURL: URL { return URL(string: Constants.baseURL)! }
    
    public var path: String {
        switch self {
        case .characters:
            return "/v1/public/characters"
        case .character(let characterId):
            return "/v1/public/characters/\(characterId)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .characters,
             .character:
            return .get
        }
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .characters(let query):
            guard let query = query else { return authParameters() }
            return authParameters(with: Constants.queryCharactersKey, query: query)
            
        case .character(let query):
            return authParameters(with: Constants.queryCharacterKey, query: query)
        }
    }
    
    public var task: Task {
        return .requestPlain
    }
    
    public var sampleData: Data {
        switch self {
        default:
            return Data()
        }
    }
    
}


// MARK: - Auth and Additional parameters

private extension NetworkAPI {
    
    /// Returns a dictionary with the auth parameters needed to make the request valid.
    /// Also it supports additional queries through the `key` and `query` variables.
    /// - Parameters:
    ///         - key: A `String` containing the key for the additional query
    ///         - value: A `String` containing the value for the additional query
    func authParameters(with key: String? = nil, query: String? = nil) -> [String: String] {
        var authParameters = ["apikey": Constants.apikey,
                              "ts": Constants.timestamp,
                              "hash": Constants.hash]
        
        if let key = key, let query = query {
            authParameters[key] = query
        }
        
        return authParameters
    }
    
}
