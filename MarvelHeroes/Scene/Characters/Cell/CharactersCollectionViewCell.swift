//
//  CharactersCollectionViewCell.swift
//  MarvelHeroes
//
//  Created by Mayckon B on 16.11.20.
//

import UIKit
import SnapKit
import MarvelDomain

class CharactersCollectionViewCell: UICollectionViewCell {
    // MARK: - Constants
    private enum Constants {
        static let nameFont: CGFloat = 17
        static let margin: CGFloat = 16
    }
    
    // MARK: - UI Properties
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = .systemFont(ofSize: Constants.nameFont, weight: .regular)
        return label
    }()
    
    private let characterImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    // MARK: - Config cell
    
    func setup(character: Character) {
        nameLabel.text = character.name
        characterImageView.download(image: character.thumbnail?.fullPath ?? "")
    }
}

// MARK: - Setup layout

private extension CharactersCollectionViewCell {
    
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        addSubview(characterImageView)
        addSubview(nameLabel)
        
        nameLabel.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        nameLabel.textColor = .white
    }
    
}

// MARK: - Constraints

private extension CharactersCollectionViewCell {
    
    func setupConstraints() {
        setupImageViewConstraints()
        setupLabelConstraints()
    }
    
    func setupImageViewConstraints() {
        characterImageView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
    }
    
    func setupLabelConstraints() {
        nameLabel.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(self)
            make.leading.trailing.equalTo(self)
        }
    }
    
}
