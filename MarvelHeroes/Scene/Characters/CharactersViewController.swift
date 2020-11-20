//
//  CharactersViewController.swift
//  MarvelHeroes
//
//  Created by Mayckon B on 16.11.20.
//

import RxSwift
import RxCocoa
import ReactorKit
import UIKit
import SnapKit
import MarvelDomain
import MarvelCore

class CharactersViewController: UIViewController, View {
    // MARK: - Constants & Typealias
    typealias Section = CharactersReactor.Section
    
    // MARK: - Internal Properties
    var disposeBag = DisposeBag()
    var characterSelected: Observable<Character> {
        return collectionView.rx.modelSelected(Character.self)
            .asObservable()
    }
    
    // MARK: - Private Properties
    private let searchController = UISearchController(searchResultsController: nil)
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    private let refreshControl = UIRefreshControl()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: CharactersViewController.collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.canCancelContentTouches = false
        collectionView.backgroundColor = .marvelBlack
        collectionView.register(CharactersCollectionViewCell.self)
        return collectionView
    }()
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Character> = {
        let dataSource = UICollectionViewDiffableDataSource
        <Section, Character>(collectionView: collectionView) { collectionView, indexPath, character in
            guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CharactersCollectionViewCell.reuseIdentifier,
                    for: indexPath) as? CharactersCollectionViewCell else { fatalError("Cannot create new cell") }
            cell.setup(character: character)
            return cell
        }
        return dataSource
    }()
    
    // MARK: - Constructor
    init(reactor: CharactersReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateSearchController()
    }
    
    // MARK: - Binding
    func bind(reactor: CharactersReactor) {
        // Actions
        
        // search query
        searchController.searchBar.rx.text
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .skip(1) // skip first empty result
            .debug("teeeeeexxxxt")
            .map { Reactor.Action.updateQuery($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // cancel filtering
        Observable.merge(searchController.searchBar.rx.cancelButtonClicked.mapToVoid().debug("cancel emiiiiiiiiiiteedddd"),
                          refreshControl.rx.controlEvent(.valueChanged).filter { self.refreshControl.isRefreshing }.mapToVoid())
        .map { Reactor.Action.updateQuery(nil) }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        // load next page
        collectionView.rx
            .nearBottom
            .throttle(.milliseconds(10), scheduler: MainScheduler.instance)
            .map { _ in Reactor.Action.loadNextPage }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // States
        
        // reload collection view
        reactor.state.map { $0.characters }
            .observeOn(MainScheduler.instance)
            .asObservable()
            .subscribe(onNext: { [weak self] characters in
                guard let self = self else { return }
                self.dataSource.apply(self.snapshot(from: characters), animatingDifferences: true)
            })
            .disposed(by: disposeBag)
        
        // animate activity indicator
        reactor.state.map { $0.isLoadingNextPage }
            .observeOn(MainScheduler.instance)
            .asObservable()
            .bind(to: loadingIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        // animate refresh control
        reactor.state.map { $0.isLoadingNextPage }
            .observeOn(MainScheduler.instance)
            .asObservable()
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        // View updates
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.updateWhenSelected(at: indexPath)
            })
            .disposed(by: disposeBag)
        
    }
    
}

// MARK: - Setup UI

private extension CharactersViewController {
    
    func setupUI() {
        setupCollectionView()
        setupSearchController()
        setupConstraints()
    }
    
    func animateSearchController() {
        UIView.setAnimationsEnabled(false)
        searchController.isActive = true
        searchController.isActive = false
        UIView.setAnimationsEnabled(true)
    }
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        view.addSubview(loadingIndicator)
        collectionView.backgroundView = loadingIndicator
        collectionView.refreshControl = refreshControl
        
        // data source
        collectionView.dataSource = dataSource
    }
    
    func setupSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
        // text color
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes
            .updateValue(UIColor.white, forKey: NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue))
    }
    
    func updateWhenSelected(at indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        view.endEditing(true)
    }
    
}

// MARK: - Setup Constraints

private extension CharactersViewController {
    
    func setupConstraints() {
        collectionViewConstraints()
    }
    
    func collectionViewConstraints() {
        collectionView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
    }
    
}
