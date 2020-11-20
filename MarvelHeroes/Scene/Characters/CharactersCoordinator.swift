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

final class CharactersCoordinator: BaseCoordinator<Void> {
    private enum Constants {
        static let title = "Characters"
    }
    
    private let window: UIWindow
    private let service: CharactersServiceType
    
    init(window: UIWindow,
         service: CharactersServiceType = CharactersService()) {
        self.window = window
        self.service = service
    }
    
    override func start() -> Observable<Void> {
        
        // setup view controller
        let viewController = CharactersViewController(reactor: CharactersReactor())
        let navigationController = self.navigationController(with: viewController)
        
        // setup window
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
         
        return .never()
    }
}

// MARK: - Navigation Controller

private extension CharactersCoordinator {
    
    func navigationController(with viewController: CharactersViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        // title
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.topItem?.title = Constants.title
        
        // color
        UINavigationBar.appearance().barTintColor = .marvelBlack
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        return navigationController
    }
    
}


