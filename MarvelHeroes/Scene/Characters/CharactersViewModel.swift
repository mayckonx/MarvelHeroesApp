//
//  CharactersViewModel.swift
//  MarvelHeroes
//
//  Created by Mayckon B on 16.11.20.
//

import Foundation
import RxSwift
import RxCocoa

protocol CharactersViewModelInput {
    
}

protocol CharactersViewModelOutput {
    
}

protocol CharactersViewModelRouting {
    
}

final class CharactersViewModel {
    private let service: CharactersServiceType
    
    init(service: CharactersServiceType) {
        self.service = service
    }
    
}
