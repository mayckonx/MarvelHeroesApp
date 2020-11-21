//
//  NetworkServiceMock.swift
//  MarvelNetworkTests
//
//  Created by Mayckon B on 21.11.20.
//

import Foundation
import RxSwift

import MarvelNetwork
import MarvelDomain

public final class NetworkServiceMock: NetworkServiceType {
    
    var response: Observable<Any>?
    var errorResponse: MarvelErrorResponse?

    public func request<T: Decodable>(_ endpoint: NetworkAPI) -> Observable<T> {
        if let error = errorResponse { return .error(error) }
        guard let response = response else { return .empty() }
        return response.map { $0 as! T }
    }
    
}
