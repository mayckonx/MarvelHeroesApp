//
//  CharactersServiceMock.swift
//  MarvelHeroesTests
//
//  Created by Mayckon B on 21.11.20.
//

import Foundation
import RxSwift

@testable import MarvelHeroes
@testable import MarvelDomain

final class CharactersServiceMock: CharactersServiceType {
    
    var characters: [Character] = []
    
    func characters(query: String? = nil, totalCharacters: Int) -> Observable<[Character]> {
        return .just(characters)
    }
}
