//
//  CharacterCoordinatorTests.swift
//  MarvelHeroesTests
//
//  Created by Mayckon B on 22.11.20.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxBlocking

@testable import MarvelHeroes
@testable import MarvelDomain

class CharacterCoordinatorTests: XCTestCase {
    // MARK: - Target to be tested
    var sut: CharacterCoordinator!
    
    // MARK: - Auxiliar Variables
    var scheduler: TestScheduler!
    var window: UIWindow!
    var bag: DisposeBag!

    // MARK: - Lifecycle
    override func setUp() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.scheduler = TestScheduler(initialClock: 0)
        self.sut = CharacterCoordinator(rootViewController: UINavigationController(), character: Character(id: 10,
                                                                                                           name: "Alien",
                                                                                                           description: "a",
                                                                                                           thumbnail: nil))
        bag = DisposeBag()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        scheduler = nil
        window = nil
        bag = nil
    }
    
    func testCoordinator_whenStart_shouldTriggerEvent() {
        // Given
        let observer = scheduler.createObserver(Void.self)
        
        // When
        sut.start()
            .bind(to: observer)
            .disposed(by: bag)
        
        scheduler.start()
        
        // Then
        XCTAssertEqual(observer.events.count, 1)
    }
    
}
