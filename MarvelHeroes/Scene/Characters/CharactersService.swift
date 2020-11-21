//
//  CharactersService.swift
//  MarvelHeroes
//
//  Created by Mayckon B on 16.11.20.
//

import Foundation
import MarvelDomain
import MarvelNetwork
import RxSwift
import Moya

protocol CharactersServiceType {
    func characters(query: String?, totalCharacters: Int) -> Observable<[Character]> 
}

final class CharactersService: CharactersServiceType {
    private enum Constants {
        static let fetchLimit = 40
    }
    
    private let networkService: NetworkServiceType
    
    init(networkService: NetworkServiceType = NetworkService()) {
        self.networkService = networkService
    }
    
    func characters(query: String? = nil, totalCharacters: Int) -> Observable<[Character]> { 
        let result : Observable<CharacterResponse> = networkService.request(.characters(query, nextPage: totalCharacters, limit: Constants.fetchLimit))
        
        return result.map { $0.characters }.distinctUntilChanged()
    }
    
}
