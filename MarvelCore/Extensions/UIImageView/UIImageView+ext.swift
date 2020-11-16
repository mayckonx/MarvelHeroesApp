//
//  UIImageView+ext.swift
//  MarvelCore
//
//  Created by Mayckon B on 16.11.20.
//

import UIKit
import Kingfisher

// MARK: - Download image

public extension UIImageView {
    
    func download(image url: String) {
        guard let imageURL = URL(string:url) else {
            return
        }
        self.kf.setImage(with: ImageResource(downloadURL: imageURL))
    }
    
}
