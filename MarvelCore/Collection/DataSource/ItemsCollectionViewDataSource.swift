//
//  ItemsCollectionViewDataSource.swift
//  MarvelCore
//
//  Created by Mayckon B on 16.11.20.
//

import UIKit

/// The `ItemsCollectionViewDataSource` represents a generic data source for collection views
public protocol ItemsCollectionViewDataSource: UICollectionViewDataSource {
    associatedtype T
    var items:[T] { get }
    var collectionView: UICollectionView? { get }
    var delegate: UICollectionViewDelegate? { get }
    
    init(items: [T], collectionView: UICollectionView, delegate: UICollectionViewDelegate)
    
    func setupCollectionView()
}

// MARK: - Setup Collection View

extension ItemsCollectionViewDataSource {
    
    public func setupCollectionView() {
        self.collectionView?.dataSource = self
        self.collectionView?.delegate = self.delegate
        self.collectionView?.reloadData()
    }
    
}
