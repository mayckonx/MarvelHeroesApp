//
//  NetworkService.swift
//  MarvelNetwork
//
//  Created by Mayckon B on 14.11.20.
//

import Foundation
import RxSwift
import Moya

/// Provides the API for network operations
public protocol NetworkServiceType {
    /// Request a response from the server using the endpoint provided as a parameter.
    /// - Parameters:
    ///         - endpoint: The API endpoint
    ///
    /// - Returns: An observable containing the mapped response
    func request<T: Decodable>(_ endpoint: NetworkAPI) -> Observable<T>
}

public final class NetworkService: NetworkServiceType {
    /// The API provider
    private let provider: MoyaProvider<NetworkAPI>
    
    /// Scheduler used for executing the operation on the background thread
    private let schedulerBackground: ConcurrentDispatchQueueScheduler
    
    public init(provider: MoyaProvider<NetworkAPI> = MoyaProvider<NetworkAPI>(),
         schedulerBackground: ConcurrentDispatchQueueScheduler = ConcurrentDispatchQueueScheduler(qos: DispatchQoS(qosClass: DispatchQoS.QoSClass.background, relativePriority: 1))) {
        self.provider = provider
        self.schedulerBackground = schedulerBackground
    }
   
    public func request<T: Decodable>(_ endpoint: NetworkAPI) -> Observable<T> {
        return provider.rx.request(endpoint)
            .observeOn(schedulerBackground)
            .asObservable()
            .filterSuccessfulStatusCodes()
            .catchError({ error -> Observable<Response> in
                guard let moyaError = (error as? MoyaError) else {
                    return .error(MarvelErrorResponse.unknown)
                }
                return .error(MarvelErrorResponseHandler.parse(from: moyaError))
            })
            .retry(1)
            .map(T.self)
    }
    
}
