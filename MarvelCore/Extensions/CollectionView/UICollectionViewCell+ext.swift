//
//  UICollectionViewCell+ext.swift
//  MarvelCore
//
//  Created by Mayckon B on 16.11.20.
//

import UIKit

// MARK: - Reusable Cell

public protocol ReusableView: class {
    static var reuseIdentifier: String { get }
}

public extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: ReusableView {}
