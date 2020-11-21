//
//  CharactersCoordinatorTests.swift
//  MarvelHeroesTests
//
//  Created by Mayckon B on 20.11.20.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxBlocking

@testable import MarvelHeroes

class CharactersCoordinatorTests: XCTestCase {
    // MARK: - Target to be tested
    var sut: CharactersCoordinator!
    
    // MARK: - Auxiliar Variables
    var window: UIWindow!
    var bag: DisposeBag!

    // MARK: - Lifecycle
    override func setUp() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.sut = CharactersCoordinator(window: window)
        bag = DisposeBag()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        window = nil
        bag = nil
    }
    
    func testCoordinator_whenStart_shouldTriggerEvent() {
        // When
        guard let result = try? sut.start().toBlocking().toArray() else {
            XCTFail("Coordinator has failed to start the scene")
            return
        }
        
        // Then
        XCTAssertEqual(result.count, 1)
    }
}
