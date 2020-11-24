//
//  CharacterCoordinatorDelegateMock.swift
//  MarvelHeroesTests
//
//  Created by Mayckon B on 24.11.20.
//

import Foundation
@testable import MarvelHeroes
@testable import MarvelDomain

final class CharacterCoordinatorDelegateMock: CharacterCoordinatorDelegate {
    private(set) var dismissCount: Int = 0
    
    func dismiss() {
        dismissCount += 1
    }
}

