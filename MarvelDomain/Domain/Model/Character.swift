//
//  Character.swift
//  MarvelDomain
//
//  Created by Mayckon B on 16.11.20.
//

import Foundation

public struct Character: Decodable {
    var id: Int
    var name: String
    var description: String
    var thumbnail: ThumbImage?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case thumbnail
    }
}

// MARK: - Equatable

extension Character: Equatable {
    
    public static func ==(lhs: Character, rhs: Character) -> Bool {
        return lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.description == rhs.description &&
            lhs.thumbnail == rhs.thumbnail
    }
    
}
