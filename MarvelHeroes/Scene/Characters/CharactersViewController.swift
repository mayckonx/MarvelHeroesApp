//
//  CharactersViewController.swift
//  MarvelHeroes
//
//  Created by Mayckon B on 16.11.20.
//

import RxSwift
import RxCocoa
import UIKit
import SnapKit

class CharactersViewController: UIViewController {
    private enum Constants {
        static let rowHeight: CGFloat = 80
        static let progressBarFilled: Float = 1.0
        static let progressBarEmpty: Float = 0.0
    }
    
    // MARK: - Private Properties
    private let bag = DisposeBag()
    private let viewModel: CharactersViewModel
    
    // MARK: - Private UI Properties
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.tableFooterView = UIView() //Prevent empty row
        tableView.estimatedRowHeight = Constants.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    private let progressView: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .bar)
        view.backgroundColor = UIColor.gray
        view.progressTintColor = .systemBlue
        view.trackTintColor = .gray
        view.progress = 0
        
        return view
    }()
    
    private let refreshButton: UIBarButtonItem = {
        let view = UIBarButtonItem(systemItem: .refresh)
        
        return view
    }()
    
    private let cancelButton: UIBarButtonItem = {
        let view = UIBarButtonItem(systemItem: .cancel)
        
        return view
    }()
    
    // MARK: - Constructor
    init(viewModel: CharactersViewModel) {
        self.viewModel = viewModel
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
    
}

// MARK: - Setup UI

private extension CharactersViewController {
    
    func setupUI() {
        setupTableView()
    }
    
    func setupTableView() {
        // add
        view.addSubview(tableView)
        
        // progress view
        tableView.tableHeaderView = progressView
        
        // add constraints
        //tableView.pinEdges()
    }
    
    func showInitialState() {
        // UI in initial state
       // showButton(.refresh)
        progressView.progress = Constants.progressBarEmpty
        progressView.isHidden = true
    }
    
}
