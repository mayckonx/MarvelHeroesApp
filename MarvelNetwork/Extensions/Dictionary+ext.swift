//
//  Dictionary+ext.swift
//  MarvelCore
//
//  Created by Mayckon B on 18.11.20.
//

import Foundation

extension Dictionary {
    /// Merges two dictionaries into one.
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}
