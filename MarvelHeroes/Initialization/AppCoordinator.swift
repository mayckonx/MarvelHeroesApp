//
//  AppCoordinator.swift
//  MarvelHeroes
//
//  Created by Mayckon B on 13.11.20.
//

import Foundation
import RxSwift
import MarvelCore

final class AppCoordinator: BaseCoordinator<Void> {
    /// App main window
    private let window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
        super.init()
    }
    
    override func start() -> Observable<Void> {
        guard let window = window else { return .empty() }
        return CharactersCoordinator(window: window).start()
    }
}
