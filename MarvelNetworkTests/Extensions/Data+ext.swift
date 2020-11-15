//
//  Data+ext.swift
//  MarvelNetworkTests
//
//  Created by Mayckon B on 15.11.20.
//

import Foundation

// MARK: - Convert to decodable object

extension Data {
    
    func decodeTo<T: Decodable>(object: T.Type) -> T? {
        return try? JSONDecoder().decode(T.self, from: self)
    }
    
}
