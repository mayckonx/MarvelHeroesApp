//
//  CharactersCollectionDataSource.swift
//  MarvelHeroes
//
//  Created by Mayckon B on 16.11.20.
//

import MarvelCore
import UIKit
import MarvelDomain

final class CharactersCollectionDataSource: NSObject, ItemsCollectionViewDataSource {
    
    // MARK: - Public vars
    var items: [Character] = []
    weak var collectionView: UICollectionView?
    weak var delegate: UICollectionViewDelegate?
    
    // MARK: - Private vars
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    required init(items: [Character], collectionView: UICollectionView, delegate: UICollectionViewDelegate) {
        self.items = items
        self.collectionView = collectionView
        self.delegate = delegate
        super.init()
        collectionView.register(CharactersCollectionViewCell.self)
        self.setupCollectionView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(for: indexPath) as? CharactersCollectionViewCell else { return UICollectionViewCell() }
        let character = self.items[indexPath.row]
        cell.setup(character: character)
        return cell
    }
}

// MARK: - Collection View Layout

extension CharactersCollectionDataSource: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // 2 items per row
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.bounds.width - paddingSpace
        let widthPerItem = (availableWidth / itemsPerRow)
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
}
