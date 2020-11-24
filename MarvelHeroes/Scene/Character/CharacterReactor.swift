//
//  CharacterReactor.swift
//  MarvelHeroes
//
//  Created by Mayckon B on 21.11.20.
//

import Foundation
import ReactorKit
import MarvelDomain

final class CharacterReactor: Reactor {
    enum Section: Hashable {
        case main
    }
    
    enum Action {
        case showCharacter
        case dismiss
    }
    
    enum Mutation {
        case setCharacterData(Character)
        case dismiss
    }
    
    struct State {
        var character: Character?
        var shouldDismiss: Bool = false
    }
    
    let initialState = State()
    private let character: Character
    
    init(_ character: Character) {
        self.character = character
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .showCharacter:
            var character = self.character
            character.description = character.description.isEmpty ? "No description" : character.description
            return .just(Mutation.setCharacterData(character))
        case .dismiss:
            return .just(.dismiss)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setCharacterData(character):
            var newState = state
            newState.character = character
            newState.shouldDismiss = false
            return newState
        case .dismiss:
            var newState = state
            newState.shouldDismiss = true
            return newState
        }
    
    }
}
