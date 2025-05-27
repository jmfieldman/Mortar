//
//  MortarReactive.swift
//  Copyright © 2025 Jason Fieldman.
//

import CombineEx

// MARK: - Bind Target

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

// MARK: - Sink

public protocol _MortarSinkProviding: AnyObject {
    @discardableResult
    func sink<Binder, Output, E: Error>(
        _ publisher: any Publisher<Output, E>,
        receiveValue: ((Binder, Output) -> Void)?,
        receiveCompletion: ((Binder, Subscribers.Completion<E>) -> Void)?
    ) -> AnyCancellable where Binder == Self

    @discardableResult
    func sink<Binder, Output>(
        _ publisher: any Publisher<Output, Never>,
        receiveValue: ((Binder, Output) -> Void)?
    ) -> AnyCancellable where Binder == Self
}

public extension _MortarSinkProviding {
    @discardableResult
    func sink<Binder, Output, E: Error>(
        _ publisher: any Publisher<Output, E>,
        receiveValue: ((Binder, Output) -> Void)? = nil,
        receiveCompletion: ((Binder, Subscribers.Completion<E>) -> Void)? = nil
    ) -> AnyCancellable where Binder == Self {
        publisher.eraseToAnyPublisher()
            .receiveOnMain()
            .sink(
                duringLifetimeOf: self,
                receiveValue: { [weak self] in
                    guard let self else { return }
                    receiveValue?(self, $0)
                },
                receiveCompletion: { [weak self] in
                    guard let self else { return }
                    receiveCompletion?(self, $0)
                }
            )
    }

    @discardableResult
    func sink<Binder, Output>(
        _ publisher: any Publisher<Output, Never>,
        receiveValue: ((Binder, Output) -> Void)?
    ) -> AnyCancellable where Binder == Self {
        publisher.eraseToAnyPublisher()
            .receiveOnMain()
            .sink(
                duringLifetimeOf: self,
                receiveValue: { [weak self] in
                    guard let self else { return }
                    receiveValue?(self, $0)
                }
            )
    }
}

extension MortarView: _MortarSinkProviding {}

// MARK: - Observe

public protocol _MortarPropertyProviding: MortarView {
    func property<Source, T>(
        _ keyPath: KeyPath<Source, T>
    ) -> Property<T> where Source == Self
}

public extension _MortarPropertyProviding {
    func property<T>(
        _ keyPath: KeyPath<Self, T>
    ) -> Property<T> {
        let mutableProperty = MutableProperty(self[keyPath: keyPath])
        let property = Property(mutableProperty)

        let kvoToken = observe(keyPath) { obj, _ in
            mutableProperty.value = obj[keyPath: keyPath]
        }

        permanentlyAssociate(kvoToken)
        permanentlyAssociate(property)

        return property
    }
}

extension MortarView: _MortarPropertyProviding {}
