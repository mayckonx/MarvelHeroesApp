//
//  CharactersCollectionViewCell.swift
//  MarvelHeroes
//
//  Created by Mayckon B on 16.11.20.
//

import UIKit
import SnapKit
import MarvelDomain
import MarvelCore

class CharactersCollectionViewCell: UICollectionViewCell {
    // MARK: - Constants
    private enum Constants {
        static let nameFont: CGFloat = 16
        static let margin: CGFloat = 5
        static let cornerRadius: CGFloat = 5
        static let bottomLabelHeight: CGFloat = 40
        static let backgroundAlpha: CGFloat = 0.4
    }
    
    // MARK: - UI Properties
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textAlignment = .left
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: Constants.nameFont, weight: .semibold)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    
    private let bottomLabelView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(Constants.backgroundAlpha)
        
        return view
    }()
    
    private let characterImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        
        return view
    }()
    
    // MARK: - Config cell
    
    func setup(character: Character) {
        nameLabel.text = character.name
        characterImageView.download(image: character.thumbnail?.fullPath ?? "")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setupUI()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        layer.cornerRadius = Constants.cornerRadius
        layer.masksToBounds = true
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
        addSubview(bottomLabelView)
        bottomLabelView.addSubview(nameLabel)
        
        nameLabel.textColor = .white
    }
    
}

// MARK: - Constraints

private extension CharactersCollectionViewCell {
    
    func setupConstraints() {
        setupImageViewConstraints()
        setupBottomViewConstraints()
        setupLabelConstraints()
    }
    
    func setupImageViewConstraints() {
        characterImageView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
    }
    
    func setupBottomViewConstraints() {
        bottomLabelView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(Constants.bottomLabelHeight)
            make.bottom.equalTo(self)
            make.leading.trailing.equalTo(self)
        }
    }
    
    func setupLabelConstraints() {
        nameLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(bottomLabelView)
            make.leading.equalTo(self).offset(Constants.margin)
            make.trailing.equalTo(self).inset(Constants.margin)
        }
    }
    
}
