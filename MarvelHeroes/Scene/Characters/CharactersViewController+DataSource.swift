//
//  CharactersViewController+DataSource.swift
//  MarvelHeroes
//
//  Created by Mayckon B on 18.11.20.
//

import UIKit
import MarvelDomain

extension CharactersViewController {
    
    typealias ItemsSnapshot = NSDiffableDataSourceSnapshot<Section, Character>
    
    // MARK: - Static properties
    
    static let collectionViewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            let twoItems = NSCollectionLayoutItem(
              layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/2),
                heightDimension: .fractionalHeight(1.0)))
            twoItems.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

            let twoItemsGroup = NSCollectionLayoutGroup.horizontal(
              layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1/4)),
              subitems: [twoItems, twoItems])
            
            let nestedGroup = NSCollectionLayoutGroup.vertical(
              layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)),
              subitems: [twoItemsGroup])
            
            let section = NSCollectionLayoutSection(group: nestedGroup)
            return section
        }
        return layout
    }()
    
    // MARK: - Public methods
    
    func snapshot(from characters: [Character]) -> ItemsSnapshot {
        var snapshot = ItemsSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(characters)
        
        return snapshot
    }
    
}
