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
import RxExpect

@testable import MarvelHeroes
@testable import MarvelDomain

class CharacterCoordinatorTests: XCTestCase {
    // MARK: - Target to be tested
    var sut: CharacterCoordinator!
    
    // MARK: - Auxiliar Variables
    var delegateMock: CharacterCoordinatorDelegateMock!
    var scheduler: TestScheduler!
    var bag: DisposeBag!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        self.delegateMock = CharacterCoordinatorDelegateMock()
        self.scheduler = TestScheduler(initialClock: 0)
        bag = DisposeBag()
    }
    
    override func tearDown() {
        super.tearDown()
        delegateMock = nil
        sut = nil
        scheduler = nil
        bag = nil
    }
    
    func testCoordinator_whenStart_shouldTriggerEvent() {
        // Given
        self.sut = CharacterCoordinator(rootViewController: UINavigationController(), character: Character(id: 10,
                                                                                                           name: "Alien",
                                                                                                           description: "a",
                                                                                                           thumbnail: nil))
        let observer = scheduler.createObserver(Void.self)
        
        // When
        sut.start()
            .bind(to: observer)
            .disposed(by: bag)
        
        scheduler.start()
        
        // Then
        XCTAssertEqual(observer.events.count, 1)
    }
    
    func testDelegate_whenPressDismissButton_shouldTriggerIt() {
        // Given
        // 1. setup coordinator and view controller
        let character = Character.init(id: 10, name: "Alliens", description: "Pretty dangerous element", thumbnail: nil)
        let viewControllerReactor = CharacterReactor(character)
        let viewController = CharacterViewController(coordinatorDelegate: delegateMock)
        viewController.reactor = viewControllerReactor
        sut = CharacterCoordinator(rootViewController: UINavigationController(),
                                   character: character,
                                   viewController: viewController)
        
        // 2. set up test input
        let test = RxExpect()
        let reactor = test.retain(viewControllerReactor)
        test.input(reactor.action, [Recorded.next(100, .dismiss)])
        
        // When
        let characterSelected = reactor.state.map { $0.shouldDismiss }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in self.delegateMock.dismissCount }
        
        // Then
        test.assert(characterSelected) { result in
            XCTAssertEqual(result, [
                Recorded.next(100, 1)
            ])
        }
    }
    
}
