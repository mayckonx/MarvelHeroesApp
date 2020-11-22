//
//  CharactersReactorTests.swift
//  MarvelHeroesTests
//
//  Created by Mayckon B on 20.11.20.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxExpect

@testable import MarvelHeroes
@testable import MarvelNetwork
@testable import MarvelDomain

class CharactersReactorTests: XCTestCase {
    // MARK: - Target to be tested
    var sut: CharactersReactor!
    
    // MARK: - Auxiliar Variables
    var charactersServiceMock: CharactersServiceMock!
    var scheduler: TestScheduler!
    var bag: DisposeBag!

    // MARK: - Lifecycle
    override func setUp() {
        charactersServiceMock = CharactersServiceMock()
        scheduler = TestScheduler(initialClock: 0)
        sut = CharactersReactor(service: charactersServiceMock)
        bag = DisposeBag()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        charactersServiceMock = nil
        scheduler = nil
        bag = nil
    }
    
    // MARK: - Tests
    
    func testReactor_whenReceiveLoadNextPage_shouldTriggerLoading() {
        // Given
        let test = RxExpect()
        let reactor = test.retain(sut)
        test.input(reactor.action, [Recorded.next(100, .loadNextPage)])
        
        // When
        let isLoadingNextPage = reactor.state.map { $0.isLoadingNextPage }.distinctUntilChanged()
        
        // Then
        test.assert(isLoadingNextPage) { isLoading in
            XCTAssertEqual(isLoading, [
                Recorded.next(0, false), // start
                Recorded.next(100, true), // loading data
                Recorded.next(100, false) // load data is finished
            ])
        }
    }
    
    func testReactor_whenFetchData_shouldHaveCharacters() {
        // Given
        
        // prepare service
        let mockedCharacters = Bundle.loadResponse(name: "characters-response")!.decodeTo(object: CharacterResponse.self)!.characters
        charactersServiceMock.characters = mockedCharacters
        
        // set up test input
        let test = RxExpect()
        let reactor = test.retain(sut)
        test.input(reactor.action, [Recorded.next(100, .loadNextPage)])
        
        // When
        let charactersResponse = reactor.state.map { $0.characters }.distinctUntilChanged()
        
        // Then
        test.assert(charactersResponse) { characters in
            XCTAssertEqual(characters, [
                Recorded.next(0, []),
                Recorded.next(100, mockedCharacters)
            ])
        }
    }
    
    func testReactor_whenFetchDataFromQuery_shouldHaveCharacters() {
        // Given
        
        // prepare service
        let mockedCharacters = Bundle.loadResponse(name: "characters-response")!.decodeTo(object: CharacterResponse.self)!.characters
        charactersServiceMock.characters = mockedCharacters
        
        // set up test input
        let test = RxExpect()
        let reactor = test.retain(sut)
        test.input(reactor.action, [Recorded.next(100, .updateQuery("Ac"))])
        
        // When
        let charactersResponse = reactor.state.map { $0.characters }.distinctUntilChanged()
        
        // Then
        test.assert(charactersResponse) { characters in
            XCTAssertEqual(characters, [
                Recorded.next(0, []),
                Recorded.next(100, mockedCharacters)
            ])
        }
    }
    
    func testReactor_whenSelectIndex_shouldEmitCharacterSelected() {
        // Given
        
        // prepare service
        let mockedCharacters = Bundle.loadResponse(name: "characters-response")!.decodeTo(object: CharacterResponse.self)!.characters
        let expectedCharacter = Optional(mockedCharacters[1])
        charactersServiceMock.characters = mockedCharacters
        
        // set up test input
        let test = RxExpect()
        let reactor = test.retain(sut)
        test.input(reactor.action, [Recorded.next(100, .loadNextPage),
                                    Recorded.next(200, .characterAt(1))])
        
        // When
        let characterResponse = reactor.state.map { $0.character }.distinctUntilChanged()
        
        // Then
        test.assert(characterResponse) { character in
            XCTAssertEqual(character, [
                Recorded.next(0, nil),
                Recorded.next(200, expectedCharacter)
            ])
        }
    }
    
    func testReactorPagination_whenLoadNextPageMultipleTimes_shouldBringIncrementalData() {
        // Given
        let mockedCharacters = Bundle.loadResponse(name: "characters-response")!.decodeTo(object: CharacterResponse.self)!.characters
        let secondPage = mockedCharacters + mockedCharacters
        let thirdPage = secondPage + mockedCharacters
        // prepare service
        charactersServiceMock.characters = mockedCharacters
        
        // set up test input
        let test = RxExpect()
        let reactor = test.retain(sut)
        test.input(reactor.action, [Recorded.next(100, .loadNextPage),
                                    Recorded.next(200, .loadNextPage),
                                    Recorded.next(300, .loadNextPage)])
        
        // When
        let charactersResponse = reactor.state.map { $0.characters }.distinctUntilChanged()
        
        // Then
        test.assert(charactersResponse) { characters in
            XCTAssertEqual(characters, [
                Recorded.next(0, []),
                Recorded.next(100, mockedCharacters),
                Recorded.next(200, secondPage),
                Recorded.next(300, thirdPage)
            ])
        }
    }
    
}

