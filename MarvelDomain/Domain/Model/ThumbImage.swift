//
//  ThumbImage.swift
//  MarvelDomain
//
//  Created by Mayckon B on 16.11.20.
//

import Foundation

public struct ThumbImage: Decodable {
    var path: String
    var imageExtension: String
    
    enum CodingKeys: String, CodingKey {
        case path
        case imageExtension = "extension"
    }
}

// MARK: - Image full path

extension ThumbImage {
    
   public var fullPath: String {
        return "\(path).\(imageExtension)"
    }
    
}

// MARK: - Equatable

extension ThumbImage: Hashable {
    
    public static func == (lhs: ThumbImage, rhs: ThumbImage) -> Bool {
        return lhs.path == rhs.path && lhs.imageExtension == rhs.imageExtension
    }
    
}


