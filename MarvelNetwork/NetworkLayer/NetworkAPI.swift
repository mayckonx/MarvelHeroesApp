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

public enum NetworkAPI: TargetType, AccessTokenAuthorizable  {
    
    private enum Constants {
    
        // MARK: -  API Setup
        
        private static let keys = MarvelHeroesKeys()
        static let baseURL = "https://gateway.marvel.com:443"
        static let privatekey = keys.marvelPrivateKey
        static let apikey = keys.marvelApiKey
        static let timestamp = Date().timeIntervalSince1970.description
        static let hash = "\(timestamp)\(privatekey)\(apikey)".md5
        
        // MARK: - Queries
        static let queryCharactersLimitKey = "limit"
        static let queryCharactersNextPageKey = "offset"
        static let queryCharactersSearchKey = "nameStartsWith"
        static let queryCharacterKey = "characterId"
        static let queryOrderBy = "orderBy"
    }
    
    // characters
    case characters(_ nameStartsWith: String? , nextPage: Int, limit: Int)
    case character(_ characterId: String)
    
}

// MARK: - API Config

extension NetworkAPI  {
    
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
        case let .characters(query, nextPage, limit):
            var queries: [String: String] = [
                Constants.queryCharactersNextPageKey: "\(nextPage)",
                Constants.queryCharactersLimitKey: "\(limit)",
                Constants.queryOrderBy: "name"
            ]
                                            
            if let query = query {
                queries[Constants.queryCharactersSearchKey] = query
            }
            return authParameters(with: queries)
            
        case let .character(query):
            return authParameters(with: [Constants.queryCharacterKey: query])
        }
    }
    
    public var task: Task {
        guard let parameters = parameters else { return .requestPlain }
        return.requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
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
    ///         - queries: A `Dictionary` containing the key/values for the parameters
    func authParameters(with queries: [String: String] = [:]) -> [String: String] {
        var authParameters = ["apikey": Constants.apikey,
                              "ts": Constants.timestamp,
                              "hash": Constants.hash]
        
        authParameters.merge(dict: queries)
        
        return authParameters
    }
    
}
