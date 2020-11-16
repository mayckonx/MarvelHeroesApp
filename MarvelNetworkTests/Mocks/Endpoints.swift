//
//  Endpoints.swift
//  MarvelNetworkTests
//
//  Created by Mayckon B on 15.11.20.
//

import Foundation
import Moya

@testable import MarvelNetwork

struct Endpoints {
    static func response(_ target: NetworkAPI) -> Endpoint {
        return Endpoint(url: URL(target: target).absoluteString,
                                sampleResponseClosure: { .networkResponse(200, target.responseData) },
                                method: target.method,
                                task: target.task,
                                httpHeaderFields: target.headers)
    }
    
    static func brokenResponse(_ target: NetworkAPI) -> Endpoint {
        return Endpoint(url: URL(target: target).absoluteString,
                                sampleResponseClosure: { .networkResponse(500, target.brokenResponseData) },
                                method: target.method,
                                task: target.task,
                                httpHeaderFields: target.headers)
    }
    
    static func unauthorizedResponse(_ target: NetworkAPI) -> Endpoint {
        return Endpoint(url: URL(target: target).absoluteString,
                                sampleResponseClosure: { .networkResponse(401, target.brokenResponseData) },
                                method: target.method,
                                task: target.task,
                                httpHeaderFields: target.headers)
    }
}
