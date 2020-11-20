//
//  Character.swift
//  MarvelDomain
//
//  Created by Mayckon B on 16.11.20.
//

import Foundation

public struct Character: Decodable {
    public var id: Int
    public var name: String
    public var description: String
    public var thumbnail: ThumbImage?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case thumbnail
    }
}

// MARK: - Hashable

extension Character: Hashable {
    
    public static func ==(lhs: Character, rhs: Character) -> Bool {
        return lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.description == rhs.description &&
            lhs.thumbnail == rhs.thumbnail
    }
    
}
