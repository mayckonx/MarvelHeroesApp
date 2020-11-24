//
//  CharactersCollectionViewCellTests.swift
//  MarvelHeroesTests
//
//  Created by Mayckon B on 24.11.20.
//

import XCTest
import UIKit

@testable import MarvelHeroes
@testable import MarvelDomain

class CharactersCollectionViewCellTests: XCTestCase {
    // MARK: - Target to be tested
    var sut: CharactersCollectionViewCell!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        self.sut = CharactersCollectionViewCell(frame: .zero)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testCell_whenStart_shouldHaveTextAndImageAsNil() {
        // When
        sut = CharactersCollectionViewCell(frame: .zero)
        
        // Then
        XCTAssertNil(sut.nameLabel.text)
        XCTAssertNil(sut.characterImageView.image)
    }

    
    func testCell_whenSetupCharacter_shouldUpdateUI() {
        // Given
        let character = Character.init(id: 23, name: "Allien", description: "", thumbnail: nil)
        
        // When
        sut.setup(character: character)
        
        // Then
        XCTAssertEqual(sut.nameLabel.text, character.name)
        XCTAssertEqual(sut.characterImageView.image, UIImage(named: "placeholder"))
    }
}
