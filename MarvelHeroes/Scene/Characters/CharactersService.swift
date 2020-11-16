//
//  CharactersService.swift
//  MarvelHeroes
//
//  Created by Mayckon B on 16.11.20.
//

import Foundation
import MarvelNetwork

protocol CharactersServiceType {
    
}

final class CharactersService: CharactersServiceType {
    private let networkService: NetworkServiceType
    
    init(networkService: NetworkServiceType = NetworkService()) {
        self.networkService = networkService
    }
    
}
