//
//  CharactersReactor.swift
//  MarvelHeroes
//
//  Created by Mayckon B on 17.11.20.
//

import Foundation
import ReactorKit
import MarvelDomain

final class CharactersReactor: Reactor {
    enum Section: Hashable {
        case main
    }
    
    enum Action {
        case updateQuery(String?)
        case loadNextPage
    }
    
    enum Mutation {
        case setQuery(String?)
        case setItems([Character], String?)
        case appendItems([Character])
        case setLoadingNextPage(Bool)
    }
    
    struct State {
        var query: String?
        var characters: [Character] = []
        var isLoadingNextPage: Bool = false
    }
    
    let initialState = State()
    private let service: CharactersServiceType
    
    init(service: CharactersServiceType = CharactersService()) {
        self.service = service
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateQuery(query):
            return Observable.concat([
                // 1. set loading page to true
                .just(.setLoadingNextPage(true)),
                
                // 2. fetch characters
                self.fetchCharacters(query: query, totalCharacters: 0)
                 // cancel previous request when the new `.updateQuery` action is fired
                 .takeUntil(self.action.filter(Action.isUpdateQueryAction))
                  .map { Mutation.setItems($0, query) },
                
                // 3. stops loading page
                .just(.setLoadingNextPage(false))
            ])
        case .loadNextPage:
            guard !self.currentState.isLoadingNextPage else { return .empty() }
            return Observable.concat([
                // 1. set loading page to true
                .just(.setLoadingNextPage(true)),
                
                // 2. fetch characters and append it to the end of the list
                self.fetchCharacters(query: currentState.query, totalCharacters: currentState.characters.count)
                 // cancel previous request when the new `.updateQuery` action is fired
                 .takeUntil(self.action.filter(Action.isUpdateQueryAction))
                  .map { Mutation.appendItems($0) },
                
                // 3. stops loading page
                .just(.setLoadingNextPage(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setQuery(query):
            var newState = state
            newState.query = query
            return newState
        case let .setItems(characters, query):
            var newState = state
            newState.query = query
            newState.characters = characters
            return newState
        case let .appendItems(characters):
            var newState = state
            newState.characters.append(contentsOf: characters)
            return newState
        case let .setLoadingNextPage(isLoadingNextPage):
            var newState = state
            newState.isLoadingNextPage = isLoadingNextPage
            return newState
        }
    
    }
}

// MARK: - Fetch characters

private extension CharactersReactor {
    
    func fetchCharacters(query: String? = nil, totalCharacters: Int) -> Observable<[Character]> {
        return service.characters(query: query, totalCharacters: totalCharacters)
    }
    
}

// MARK: - Action extension

private extension CharactersReactor.Action {
  static func isUpdateQueryAction(_ action: CharactersReactor.Action) -> Bool {
    if case .updateQuery = action {
      return true
    } else {
      return false
    }
  }
}
