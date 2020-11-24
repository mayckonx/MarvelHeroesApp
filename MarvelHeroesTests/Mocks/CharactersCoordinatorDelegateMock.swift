//
//  CharactersCoordinatorDelegateMock.swift
//  MarvelHeroesTests
//
//  Created by Mayckon B on 24.11.20.
//

import Foundation
@testable import MarvelHeroes
@testable import MarvelDomain

final class CharactersCoordinatorDelegateMock: CharactersCoordinatorDelegate {
    private(set) var showCharacterCount: Int = 0
    
    func showCharacter(_ character: Character) {
        showCharacterCount += 1
    }
}
