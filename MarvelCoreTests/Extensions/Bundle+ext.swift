//
//  Bundle+ext.swift
//  MarvelNetworkTests
//
//  Created by Mayckon B on 15.11.20.
//

import Foundation

// MARK: - Load resource

public extension Bundle {
    
    /// Loads a json with mocked data and converts it into a `Data`
    static func loadResponse(name: String, target: AnyClass = MockClass.self, fileExtension: String = "json") -> Data? {
        let url = Bundle(for: target).url(forResource: name, withExtension: fileExtension)!
        return try? Data(contentsOf: url)
    }
    
}

public final class MockClass {}
