//
//  CharacterReactorTests.swift
//  MarvelHeroesTests
//
//  Created by Mayckon B on 22.11.20.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxExpect

@testable import MarvelHeroes
@testable import MarvelNetwork
@testable import MarvelDomain

class CharacterReactorTests: XCTestCase {
    // MARK: - Target to be tested
    var sut: CharacterReactor!
    
    // MARK: - Auxiliar Variables
    var scheduler: TestScheduler!
    var bag: DisposeBag!

    // MARK: - Lifecycle
    override func setUp() {
        scheduler = TestScheduler(initialClock: 0)
        bag = DisposeBag()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        scheduler = nil
        bag = nil
    }
    
    // MARK: - Tests
    
    func testReactor_whenSendActionToShowCharacter_shouldTriggerCharacter() {
        // Given
        let expectedCharacter = Character.init(id: 10, name: "Alien", description: "jfoasifjdsaiofjsdaiojfdsaifsa", thumbnail: nil)
        sut = CharacterReactor(expectedCharacter)
        let test = RxExpect()
        let reactor = test.retain(sut)
        test.input(reactor.action, [Recorded.next(100, .showCharacter)])
        
        // When
        let characterResult = reactor.state.map { $0.character }.filterNil().distinctUntilChanged()
        
        // Then
        test.assert(characterResult) { character in
            XCTAssertEqual(character, [
                Recorded.next(100, expectedCharacter)
            ])
        }
    }
    
    func testReactor_whenSendActionToShowCharacterWithoutDescription_shouldTriggerCharacterWithNoDescription() {
        // Given
        let expectedCharacter = Character.init(id: 10, name: "Alien", description: "No description", thumbnail: nil)
        sut = CharacterReactor(Character.init(id: 10, name: "Alien", description: "", thumbnail: nil))
        let test = RxExpect()
        let reactor = test.retain(sut)
        test.input(reactor.action, [Recorded.next(100, .showCharacter)])
        
        // When
        let characterResult = reactor.state.map { $0.character }.filterNil().distinctUntilChanged()
        
        // Then
        test.assert(characterResult) { character in
            XCTAssertEqual(character, [
                Recorded.next(100, expectedCharacter)
            ])
        }
    }
    
}
