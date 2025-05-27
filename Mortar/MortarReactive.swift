//
//  MortarReactive.swift
//  Copyright © 2025 Jason Fieldman.
//

import CombineEx

public struct BindTarget<Target: AnyObject, T> {
    let target: Target
    let keyPath: WritableKeyPath<Target, T>
}

public protocol _MortarBindProviding: AnyObject {
    func bind<Target, T>(
        _ keyPath: WritableKeyPath<Target, T>
    ) -> BindTarget<Target, T> where Target == Self
}

public extension _MortarBindProviding {
    func bind<T>(
        _ keyPath: WritableKeyPath<Self, T>
    ) -> BindTarget<Self, T> {
        BindTarget(target: self, keyPath: keyPath)
    }
}

extension MortarView: _MortarBindProviding {}

infix operator <~: AssignmentPrecedence

// swiftformat:disable opaqueGenericParameters

public func <~ <T, E: Error>(lhs: BindTarget<some Any, T>, rhs: any Publisher<T, E>) {
    let lhsTarget = lhs.target
    let keyPath = lhs.keyPath
    rhs.eraseToAnyPublisher()
        .receiveOnMain()
        .sink(
            duringLifetimeOf: lhsTarget,
            receiveValue: { [weak lhsTarget] value in
                lhsTarget?[keyPath: keyPath] = value
            }
        )
}

// swiftformat:enable opaqueGenericParameters

public func <~ <T>(lhs: BindTarget<some Any, T>, rhs: any Publisher<T, Never>) {
    let lhsTarget = lhs.target
    let keyPath = lhs.keyPath
    rhs.eraseToAnyPublisher()
        .receiveOnMain()
        .sink(
            duringLifetimeOf: lhsTarget,
            receiveValue: { [weak lhsTarget] value in
                lhsTarget?[keyPath: keyPath] = value
            }
        )
}
