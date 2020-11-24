//
//  CharacterViewControllerTests.swift
//  MarvelHeroesTests
//
//  Created by Mayckon B on 24.11.20.
//

import XCTest
import UIKit

@testable import MarvelHeroes
@testable import MarvelDomain

class CharacterViewControllerTests: XCTestCase {
    // MARK: - Target to be tested
    var sut: CharacterViewController!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        self.sut = CharacterViewController(coordinatorDelegate: CharacterCoordinatorDelegateMock())
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testView_whenStart_shouldHaveContentAsNil() {
        // When
        self.sut = CharacterViewController(coordinatorDelegate: CharacterCoordinatorDelegateMock())
        
        // Then
        XCTAssertNil(sut.nameLabel.text)
        XCTAssertNil(sut.descriptionLabel.text)
        XCTAssertNil(sut.characterImageView.image)
    }

    
    func testView_whenSetupCharacter_shouldUpdateUI() {
        // Given
        let character = Character.init(id: 23, name: "Allien", description: "aadfaafadsfsaa", thumbnail: nil)
        
        // When
        sut.show(character)
        
        // Then
        XCTAssertEqual(sut.nameLabel.text, character.name)
        XCTAssertEqual(sut.descriptionLabel.text, character.description)
        XCTAssertEqual(sut.characterImageView.image, UIImage(named: "placeholder"))
    }
}
