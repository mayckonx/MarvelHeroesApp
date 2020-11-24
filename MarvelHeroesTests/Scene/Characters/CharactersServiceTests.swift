//
//  CharactersServiceTests.swift
//  MarvelHeroesTests
//
//  Created by Mayckon B on 20.11.20.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxBlocking
import Moya

@testable import MarvelHeroes
@testable import MarvelNetwork
@testable import MarvelDomain

class CharactersServiceTests: XCTestCase {
    // MARK: - Target to be tested
    var sut: CharactersService!
    
    // MARK: - Auxiliar Variables
    var networkServiceMock: NetworkServiceMock!
    var response: Observable<[Character]>!
    var scheduler: TestScheduler!
    var bag: DisposeBag!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        networkServiceMock = NetworkServiceMock()
        scheduler = TestScheduler(initialClock: 0)
        sut = CharactersService(networkService: networkServiceMock)
        bag = DisposeBag()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        response = nil
        scheduler = nil
        bag = nil
    }
    
    // MARK: - Tests
    
    func testFetchCharacters_whenCallIt_shouldReceiveListOfCharacters() {
        // Given
        let expectedResult = Bundle.loadResponse(name: "characters-response")!.decodeTo(object: CharacterResponse.self)!
        networkServiceMock.response = .just(expectedResult)
        response = sut.characters(totalCharacters: 0)

        // When
        let result = try? response.toBlocking().first()!
        
        // Then
        XCTAssertNoThrow(result)
        XCTAssertTrue(result?.count ?? 0 > 0)
    }
    
    func testFetchCharacters_whenGetErrorOnResponse_shouldEmitError() {
        // Given
        let exp = expectation(description: "Results")
        let expectedResult = MarvelErrorResponse.internalServerError
        networkServiceMock.errorResponse = expectedResult
        response = sut.characters(totalCharacters: 0)

        // When
        let result = scheduler.record(response, disposeBag: bag)
        scheduler.start()
        exp.fulfill()
        
        waitForExpectations(timeout: 0.5) { _ in
            // Then
            XCTAssertEqual(result.events[0].value.error as? MarvelErrorResponse, MarvelErrorResponse.internalServerError)
        }
        
    }
    
}

