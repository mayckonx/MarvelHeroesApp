//
//  Bundle+ext.swift
//  MarvelNetworkTests
//
//  Created by Mayckon B on 15.11.20.
//

import Foundation

// MARK: - Load resource

extension Bundle {
    
    /// Loads a json with mocked data and converts it into a `Data`
    static func loadResponse(name: String, fileExtension: String = "json") -> Data? {
        let url = Bundle(for: NetworkServiceTests.self).url(forResource: name, withExtension: fileExtension)!
        return try? Data(contentsOf: url)
    }
    
}
