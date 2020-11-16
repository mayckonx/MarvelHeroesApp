//
//  CharacterResponse.swift
//  MarvelDomain
//
//  Created by Mayckon B on 16.11.20.
//

import Foundation

public struct CharacterResponse: Decodable {
    var characters: [Character]
    
    private enum CodingKeys: String, CodingKey {
        case data = "data"
    }
    
    private enum ResultKeys: String, CodingKey {
        case results = "results"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        let resultsContainer = try! container.nestedContainer(keyedBy: ResultKeys.self, forKey: .data)
        characters = try resultsContainer.decode([Character].self, forKey: .results)
    }
}
