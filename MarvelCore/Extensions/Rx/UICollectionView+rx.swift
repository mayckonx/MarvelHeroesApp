//
//  UICollectionView+rx.swift
//  MarvelCore
//
//  Created by Mayckon B on 18.11.20.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UICollectionView {
    
    public var nearBottom: Observable<Void> {
        let bottomOffset: CGFloat = 40.0
        
        func isNearBottomEdge(collectionView: UICollectionView, edgeOffset: CGFloat = bottomOffset) -> Bool {
            guard collectionView.contentSize.height >= collectionView.frame.size.height else { return false }
            
            return collectionView.contentOffset.y + collectionView.frame.size.height + edgeOffset > collectionView.contentSize.height
        }
        
        return self.contentOffset.asObservable()
            .flatMap { _ in
                return isNearBottomEdge(collectionView: self.base, edgeOffset: bottomOffset)
                    ? Observable.just(())
                    : Observable.empty()
        }
    }
    
}
