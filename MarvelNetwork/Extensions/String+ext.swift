//
//  String+ext.swift
//  MarvelNetwork
//
//  Created by Mayckon B on 14.11.20.
//

import Foundation
import CryptoKit

// MARK: - Encrypt

extension String {
    
    /// Generates a unique hash from the given string
    /// The md5 hash isn't safe, it should only be used in needed cases.
    /// Other than that using SHA512 is preferred.
    var md5: String {
        let data = Data(self.utf8)
        let hash = Insecure.MD5.hash(data: data).map { String(format: "%02hhx", $0) }.joined()
        
        return hash
    }
    
}
