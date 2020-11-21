//
//  CharactersViewController+DataSource.swift
//  MarvelHeroes
//
//  Created by Mayckon B on 18.11.20.
//

import UIKit
import MarvelDomain

extension CharactersViewController {
    private enum Constants {
        static let edgeInsets: CGFloat = 5
        static let cellWidthDimension: CGFloat = 1/2
        static let cellHeightDimension: CGFloat = 1.0
        static let cellGroupWidthDimension: CGFloat = 1.0
        static let cellGroupHeightDimension: CGFloat = 1/4
        static let cellRootGroupDimension: CGFloat = 1.0
    }
    
    typealias ItemsSnapshot = NSDiffableDataSourceSnapshot<Section, Character>
    
    // MARK: - Static properties
    
    static let collectionViewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            let twoItems = NSCollectionLayoutItem(
              layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(Constants.cellWidthDimension),
                heightDimension: .fractionalHeight(Constants.cellHeightDimension)))
            twoItems.contentInsets = NSDirectionalEdgeInsets(top: Constants.edgeInsets,
                                                             leading: Constants.edgeInsets,
                                                             bottom: Constants.edgeInsets,
                                                             trailing: Constants.edgeInsets)

            let twoItemsGroup = NSCollectionLayoutGroup.horizontal(
              layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(Constants.cellGroupWidthDimension),
                heightDimension: .fractionalHeight(Constants.cellGroupHeightDimension)),
              subitems: [twoItems, twoItems])
            
            let nestedGroup = NSCollectionLayoutGroup.vertical(
              layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(Constants.cellRootGroupDimension),
                heightDimension: .fractionalHeight(Constants.cellRootGroupDimension)),
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
