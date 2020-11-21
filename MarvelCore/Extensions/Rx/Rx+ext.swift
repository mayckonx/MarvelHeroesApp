//
//  Rx+ext.swift
//  MarvelCore
//
//  Created by Mayckon B on 18.11.20.
//

import RxSwift
import RxCocoa

// MARK: - Filter Nil
public protocol OptionalType {
    associatedtype Wrapped
    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    public var value: Wrapped? {
        return self
    }
}

extension Observable where Element: OptionalType {
    public func filterNil() -> Observable<Element.Wrapped> {
        return flatMap { (element) -> Observable<Element.Wrapped> in
            if let value = element.value {
                return .just(value)
            } else {
                return .empty()
            }
        }
    }
}

// MARK: - Map To void and Just Complete Operators
extension SharedSequenceConvertibleType {
    public func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }
}

extension ObservableType {
    public func catchErrorJustComplete() -> Observable<Element> {
        return catchError { _ in
            return Observable.empty()
        }
    }
    
    public func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { _ in
            return Driver.empty()
        }
    }
    
    public func asSignalOnErrorJustComplete() -> Signal<Element> {
        return asSignal { _ in
            return Signal.empty()
        }
    }
    
    public func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}

