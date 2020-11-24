//
//  CharacterCoordinator.swift
//  MarvelHeroes
//
//  Created by Mayckon B on 21.11.20.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit
import MarvelCore
import MarvelDomain

protocol CharacterCoordinatorDelegate: class {
    func dismiss()
}

final class CharacterCoordinator: BaseCoordinator<Void> {
    private enum Constants {
        static let title = "Characters"
    }
    
    private let rootViewController: UINavigationController
    private let character: Character
    private var viewController: CharacterViewController?
    
    init(rootViewController: UINavigationController,
         character: Character,
         viewController: CharacterViewController? = nil) {
        self.rootViewController = rootViewController
        self.character = character
        self.viewController = viewController
    }
    
    override func start() -> Observable<Void> {
        // setup view controller
        let viewController = characterViewController()
        viewController.reactor = CharacterReactor(character)
        rootViewController.present(viewController, animated: true)
         
        return .empty()
    }
}

// MARK: - Auxiliar methods

private extension CharacterCoordinator {
    
    func characterViewController() -> CharacterViewController {
        if let viewController = self.viewController {
            return viewController
        } else {
            let viewController = CharacterViewController(coordinatorDelegate: self)
            viewController.reactor = CharacterReactor(character)
            self.viewController = viewController
            return viewController
        }
    }
}

// MARK: - Delegate

extension CharacterCoordinator: CharacterCoordinatorDelegate {
    func dismiss() {
        rootViewController.presentedViewController?.dismiss(animated: true)
    }
}
