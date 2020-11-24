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
import ReactorKit
import RxBlocking
import RxExpect

@testable import MarvelHeroes
@testable import MarvelDomain

class CharactersCoordinatorTests: XCTestCase {
    // MARK: - Target to be tested
    var sut: CharactersCoordinator!
    
    // MARK: - Auxiliar Variables
    var scheduler: TestScheduler!
    var viewController: CharactersViewController!
    var delegateMock: CharactersCoordinatorDelegateMock!
    var window: UIWindow!
    var bag: DisposeBag!

    // MARK: - Lifecycle
    override func setUp() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.delegateMock = CharactersCoordinatorDelegateMock()
        self.scheduler = TestScheduler(initialClock: 0)
        bag = DisposeBag()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        scheduler = nil
        delegateMock = nil
        viewController = nil
        window = nil
        bag = nil
    }
    
    func testCoordinator_whenStart_shouldTriggerEvent() {
        // Given
        self.sut = CharactersCoordinator(window: window)
        let observer = scheduler.createObserver(Void.self)
        
        // When
        sut.start()
            .bind(to: observer)
            .disposed(by: bag)
        
        scheduler.start()
        
        // Then
        XCTAssertEqual(observer.events.count, 1)
    }
    
    func testDelegate_whenCharacterSelected_shouldTriggerIt() {
        // Given
        // 1. setup coordinator and view controller
        let charactersServiceMock = CharactersServiceMock()
        let character = Character.init(id: 10, name: "Alliens", description: "Pretty dangerous element", thumbnail: nil)
        charactersServiceMock.characters = [character]
        let viewControllerReactor = CharactersReactor(service: charactersServiceMock)
        let viewController = CharactersViewController(coordinatorDelegate: delegateMock)
        viewController.reactor = viewControllerReactor
        sut = CharactersCoordinator(window: window, viewController: viewController)
        
        // 2. set up test input
        let test = RxExpect()
        let reactor = test.retain(viewControllerReactor)
        test.input(reactor.action, [Recorded.next(100, .characterAt(0))])
        
        // When
        let characterSelected = reactor.state.map { $0.character }
            .filterNil()
            .distinctUntilChanged()
            .map { _ in self.delegateMock.showCharacterCount } 
        
        // Then
        test.assert(characterSelected) { result in
            XCTAssertEqual(result, [
                Recorded.next(100, 1)
            ])
        }
    }
}
