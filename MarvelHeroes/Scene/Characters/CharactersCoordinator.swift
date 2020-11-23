//
//  CharactersCoordinator.swift
//  MarvelHeroes
//
//  Created by Mayckon B on 16.11.20.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit
import MarvelCore
import MarvelDomain

protocol CharactersCoordinatorDelegate: class {
    func showCharacter(_ character: Character)
}

final class CharactersCoordinator: BaseCoordinator<Void> {
    // MARK: - Constants
    private enum Constants {
        static let title = "Characters"
    }
    
    // MARK: - Private variables
    private let window: UIWindow
    private let service: CharactersServiceType
    private var navigationController: UINavigationController?
    private var viewController: CharactersViewController?
    
    // MARK: - Constructor
    init(window: UIWindow,
         service: CharactersServiceType = CharactersService()) {
        self.window = window
        self.service = service
    }
    
    // MARK: - Public methods
    override func start() -> Observable<Void> {
        
        // setup view controller
        let viewController = CharactersViewController(coordinatorDelegate: self)
        viewController.reactor = CharactersReactor()
        self.viewController = viewController
        let navigationController = self.navigationController(with: viewController)
        
        // setup window
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
         
        return .empty()
    }
}

// MARK: - Navigation Controller

private extension CharactersCoordinator {
    
    func navigationController(with viewController: CharactersViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        // title
        navigationController.navigationBar.prefersLargeTitles = false
        navigationController.navigationBar.topItem?.title = Constants.title
        
        // color
        UINavigationBar.appearance().barTintColor = .marvelBlack
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        self.navigationController = navigationController
        
        return navigationController
    }
    
}

// MARK: - Delegate

extension CharactersCoordinator: CharactersCoordinatorDelegate {
    func showCharacter(_ character: Character) {
        _ = startCharacterSelected(character)
    }
}

// MARK: - Character Selected

private extension CharactersCoordinator {
    
    func startCharacterSelected(_ character: Character) -> Observable<Void> {
        guard let navigationController = navigationController else { return .empty() }
        let coordinator = CharacterCoordinator(rootViewController: navigationController, character: character)
        return coordinate(to: coordinator)
    }
    
}
