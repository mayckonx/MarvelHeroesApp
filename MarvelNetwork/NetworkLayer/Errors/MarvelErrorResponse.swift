//
//  MarvelErrorResponse.swift
//  MarvelNetwork
//
//  Created by Mayckon B on 14.11.20.
//

import Foundation

public enum MarvelErrorResponse: Error, Equatable {
    case unauthorized
    case offline
    case requestError
    case connectionTimeout
    case internalServerError
    case unknown
}

extension MarvelErrorResponse: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unauthorized, .requestError, .internalServerError, .unknown:
            return NSLocalizedString("🤭 Sorry, we've got an internal error.", comment: "")
        case .offline:
            return NSLocalizedString("📡 Please connect to the internet.", comment: "")
        case .connectionTimeout:
            return NSLocalizedString("📡 Internet connection too slow.", comment: "")
        }
    }
}
