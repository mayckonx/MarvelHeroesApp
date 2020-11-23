//
//  CharactersViewController.swift
//  MarvelHeroes
//
//  Created by Mayckon B on 16.11.20.
//

import RxSwift
import RxCocoa
import ReactorKit
import SnapKit
import MarvelDomain
import MarvelCore

class CharactersViewController: UIViewController, View {
    // MARK: - Constants & Typealias
    typealias Section = CharactersReactor.Section
    
    // MARK: - Internal Properties
    var disposeBag = DisposeBag()
    
    // MARK: - Private Properties
    private let searchController = UISearchController(searchResultsController: nil)
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    private let refreshControl = UIRefreshControl()
    private weak var coordinatorDelegate: CharactersCoordinatorDelegate?
    
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
    init(coordinatorDelegate: CharactersCoordinatorDelegate) {
        self.coordinatorDelegate = coordinatorDelegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Binding
    func bind(reactor: CharactersReactor) {
        // Actions
        
        // search query
        searchController.searchBar.rx.text.orEmpty
            .filter { !$0.isEmpty }
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map { Reactor.Action.updateQuery($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // character selected
        collectionView.rx.itemSelected
            .map { Reactor.Action.characterAt($0.row) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // cancel filtering
        Observable.merge(searchController.searchBar.rx.cancelButtonClicked.mapToVoid(),
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
            .subscribe(onNext: { [weak self] characters in
                guard let self = self else { return }
                self.dataSource.apply(self.snapshot(from: characters), animatingDifferences: true)
            })
            .disposed(by: disposeBag)
        
        // animate activity indicator
        reactor.state.map { $0.isLoadingNextPage }
            .observeOn(MainScheduler.instance)
            .bind(to: loadingIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        // animate refresh control
        reactor.state.map { $0.isLoadingNextPage }
            .observeOn(MainScheduler.instance)
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        // delegate
        reactor.state.map { $0.character }
            .observeOn(MainScheduler.instance)
            .filterNil()
            .subscribe(onNext: { [weak self] in
                self?.coordinatorDelegate?.showCharacter($0)
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
    
    func setupCollectionView() {
        // add as subivew
        view.addSubview(collectionView)
        view.addSubview(loadingIndicator)
        
        // loading/refresh component
        refreshControl.tintColor = .white
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
