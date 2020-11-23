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
    
    init(rootViewController: UINavigationController, character: Character) {
        self.rootViewController = rootViewController
        self.character = character
    }
    
    override func start() -> Observable<Void> {
        // setup view controller
        let viewController = CharacterViewController(coordinatorDelegate: self)
        viewController.reactor = CharacterReactor(character)
        rootViewController.present(viewController, animated: true)
         
        return .empty()
    }
}

// MARK: - Delegate

extension CharacterCoordinator: CharacterCoordinatorDelegate {
    func dismiss() {
        rootViewController.presentedViewController?.dismiss(animated: true)
    }
}
