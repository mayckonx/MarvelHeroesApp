//
//  CharacterViewController.swift
//  MarvelHeroes
//
//  Created by Mayckon B on 21.11.20.
//

import UIKit
import SnapKit
import ReactorKit
import RxCocoa
import MarvelCore
import MarvelDomain

class CharacterViewController: UIViewController, View {
    // MARK: - Constants
    private enum Constants {
        static let nameFont: CGFloat = 16
        static let margin: CGFloat = 20
    }
    
    // MARK: - Internal Properties
    var disposeBag = DisposeBag()
    
    // MARK: - Private Properties
    private weak var coordinatorDelegate: CharacterCoordinatorDelegate?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: Constants.nameFont, weight: .semibold)
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.setImage(UIImage(systemName: "arrow.down"), for: .normal)
        return button
    }()
    
    private let characterImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        
        return view
    }()
    
    // MARK: - Constructor
    init(coordinatorDelegate: CharacterCoordinatorDelegate) {
        self.coordinatorDelegate = coordinatorDelegate
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Binding
    func bind(reactor: CharacterReactor) {
        // Actions
        
        // view appear
        rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).take(1).mapToVoid()
            .map { Reactor.Action.showCharacter }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    
        // States
        
        // animate activity indicator
        reactor.state.map { $0.character }
            .filterNil()
            .asObservable()
            .subscribe(onNext: { [weak self] in self?.show($0) })
            .disposed(by: disposeBag)

        // view
        backButton.rx.tap.mapToVoid()
            .subscribe(onNext: { [weak self] in self?.coordinatorDelegate?.dismiss() })
            .disposed(by: disposeBag)
    }
    
    func show(_ character: Character) {
        nameLabel.text = character.name
        descriptionLabel.text = character.description
        characterImageView.download(image: character.thumbnail?.fullPath ?? "")
    }
    
}

// MARK: - Setup layout

private extension CharacterViewController {
    
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        view.addSubview(scrollView)
        view.backgroundColor = .marvelBlack

        scrollView.addSubview(contentView)
        contentView.addSubview(backButton)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(characterImageView)
        
        nameLabel.textColor = .white
        descriptionLabel.textColor = .white
        
        characterImageView.layer.cornerRadius = 10
    }
    
}

// MARK: - Constraints

private extension CharacterViewController {
    
    func setupConstraints() {
        setupScrollViewConstraints()
        setupContentViewConstraints()
        setupLabelsConstraints()
        setupBackButtonConstraints()
        setupImageViewConstraints()
    }
    
    func setupScrollViewConstraints() {
        scrollView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
            make.width.equalTo(view)
        }
    }
    
    func setupContentViewConstraints() {
        contentView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
            make.height.equalTo(scrollView).priority(.low)
        }
    }
    
    
    func setupLabelsConstraints() {
        nameLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(backButton.snp.bottom).offset(Constants.margin)
            make.height.equalTo(30)
            make.leading.equalTo(contentView).offset(Constants.margin)
            make.trailing.equalTo(contentView).inset(Constants.margin)
        }
        
        descriptionLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(characterImageView.snp.bottom).offset(Constants.margin)
            make.leading.equalTo(contentView).offset(Constants.margin)
            make.trailing.equalTo(contentView).inset(Constants.margin)
            make.bottom.equalTo(contentView).inset(Constants.margin)
            make.height.equalTo(contentView).priority(750)
        }
    }
    
    func setupBackButtonConstraints() {
        backButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(Constants.margin)
            make.leading.equalTo(contentView).offset(Constants.margin)
            make.width.equalTo(40)
            make.height.equalTo(20)
        }
    }
    
    func setupImageViewConstraints() {
        characterImageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(nameLabel.snp.bottom).offset(Constants.margin)
            make.leading.equalTo(contentView).offset(Constants.margin)
            make.trailing.equalTo(contentView).inset(Constants.margin)
            make.height.equalTo(view.frame.size.height * 0.4)
        }
    }
    
    
}
