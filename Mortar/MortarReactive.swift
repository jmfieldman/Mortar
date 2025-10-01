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

public protocol _MortarBindProviding: AnyObject {}

public extension _MortarBindProviding {
    func bind<T>(
        _ keyPath: WritableKeyPath<Self, T>
    ) -> BindTarget<Self, T> {
        BindTarget(target: self, keyPath: keyPath)
    }
}

extension NSObject: _MortarBindProviding {}

public extension MutableProperty {
    func bind() -> BindTarget<MutableProperty<Output>, Output> {
        BindTarget(target: self, keyPath: \.value)
    }
}

infix operator <~: AssignmentPrecedence

private var kBindingAssociationKey = 0

// swiftformat:disable opaqueGenericParameters

public func <~ <T, E: Error>(lhs: BindTarget<some Any, T>, rhs: any Publisher<T, E>) {
    let lhsTarget = lhs.target
    let keyPath = lhs.keyPath
    let cancellable = rhs.eraseToAnyPublisher()
        .receiveOnMain()
        .sink(
            duringLifetimeOf: lhsTarget,
            receiveValue: { [weak lhsTarget] value in
                lhsTarget?[keyPath: keyPath] = value
            }
        )

    // Bind rhs to lifetime of cancellable
    objc_setAssociatedObject(cancellable, &kBindingAssociationKey, rhs, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
}

public func <~ <T, E: Error>(lhs: BindTarget<some Any, T?>, rhs: any Publisher<T, E>) {
    let lhsTarget = lhs.target
    let keyPath = lhs.keyPath
    let cancellable = rhs.eraseToAnyPublisher()
        .receiveOnMain()
        .sink(
            duringLifetimeOf: lhsTarget,
            receiveValue: { [weak lhsTarget] value in
                lhsTarget?[keyPath: keyPath] = value
            }
        )

    // Bind rhs to lifetime of cancellable
    objc_setAssociatedObject(cancellable, &kBindingAssociationKey, rhs, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
}

// swiftformat:enable opaqueGenericParameters

public func <~ <T>(lhs: BindTarget<some Any, T>, rhs: any Publisher<T, Never>) {
    let lhsTarget = lhs.target
    let keyPath = lhs.keyPath
    let cancellable = rhs.eraseToAnyPublisher()
        .receiveOnMain()
        .sink(
            duringLifetimeOf: lhsTarget,
            receiveValue: { [weak lhsTarget] value in
                lhsTarget?[keyPath: keyPath] = value
            }
        )

    // Bind rhs to lifetime of cancellable
    objc_setAssociatedObject(cancellable, &kBindingAssociationKey, rhs, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
}

public func <~ <T>(lhs: BindTarget<some Any, T?>, rhs: any Publisher<T, Never>) {
    let lhsTarget = lhs.target
    let keyPath = lhs.keyPath
    let cancellable = rhs.eraseToAnyPublisher()
        .receiveOnMain()
        .sink(
            duringLifetimeOf: lhsTarget,
            receiveValue: { [weak lhsTarget] value in
                lhsTarget?[keyPath: keyPath] = value
            }
        )

    // Bind rhs to lifetime of cancellable
    objc_setAssociatedObject(cancellable, &kBindingAssociationKey, rhs, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
}

// MARK: - Sink

public protocol _MortarSinkProviding: AnyObject {}

public extension _MortarSinkProviding {
    @discardableResult
    func sink<Output, E: Error>(
        _ publisher: any Publisher<Output, E>,
        receiveValue: ((Self, Output) -> Void)? = nil,
        receiveCompletion: ((Self, Subscribers.Completion<E>) -> Void)? = nil
    ) -> AnyCancellable {
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
    func sink<Output>(
        _ publisher: any Publisher<Output, Never>,
        receiveValue: ((Self, Output) -> Void)?
    ) -> AnyCancellable {
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

    @discardableResult
    func sink<E: Error>(
        _ publisher: any Publisher<Void, E>,
        receiveValue: ((Self) -> Void)?,
        receiveCompletion: ((Self, Subscribers.Completion<E>) -> Void)?
    ) -> AnyCancellable {
        publisher.eraseToAnyPublisher()
            .receiveOnMain()
            .sink(
                duringLifetimeOf: self,
                receiveValue: { [weak self] in
                    guard let self else { return }
                    receiveValue?(self)
                }
            )
    }

    @discardableResult
    func sink(
        _ publisher: any Publisher<Void, Never>,
        receiveValue: ((Self) -> Void)?
    ) -> AnyCancellable {
        publisher.eraseToAnyPublisher()
            .receiveOnMain()
            .sink(
                duringLifetimeOf: self,
                receiveValue: { [weak self] in
                    guard let self else { return }
                    receiveValue?(self)
                }
            )
    }
}

extension MortarView: _MortarSinkProviding {}

// MARK: - KVO Property

public protocol _MortarKVOPropertyProviding: NSObject {}

public extension _MortarKVOPropertyProviding {
    func kvoProperty<T>(
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

extension MortarView: _MortarKVOPropertyProviding {}

// MARK: - UIControl Publish Actions

#if os(iOS) || os(tvOS)

private class TargetBox<UIControlSubtype> {
    let subject: PassthroughSubject<UIControlSubtype, Never> = .init()
    @objc func invoke(sender: UIControl) {
        if let control = sender as? UIControlSubtype {
            subject.send(control)
        }
    }
}

public protocol _MortarUIControlEventsProviding: UIControl {}

public extension _MortarUIControlEventsProviding {
    func publishEvents(
        _ filter: UIControl.Event = [.allEvents]
    ) -> AnyPublisher<Self, Never> {
        let internalTarget = TargetBox<Self>()
        permanentlyAssociate(internalTarget)
        addTarget(internalTarget, action: #selector(TargetBox<Self>.invoke(sender:)), for: filter)
        return internalTarget.subject.eraseToAnyPublisher()
    }

    func handleEvents(
        _ filter: UIControl.Event,
        _ handleBlock: @escaping @Sendable (Self) -> Void
    ) {
        publishEvents(filter)
            .sink(
                duringLifetimeOf: self,
                receiveValue: handleBlock
            )
    }

    func handleEvents(
        _ filter: UIControl.Event,
        _ actionTrigger: some ActionTriggerConvertible<Self>
    ) {
        let resolvedActionTrigger = actionTrigger.asActionTrigger
        publishEvents(filter)
            .sink(
                duringLifetimeOf: self,
                receiveValue: { _ in
                    resolvedActionTrigger
                        .applyAnonymous(self)
                        .sink(duringLifetimeOf: self)
                }
            )
    }

    func handleEvents(
        _ filter: UIControl.Event,
        _ actionTrigger: some ActionTriggerConvertible<Void>
    ) {
        let resolvedActionTrigger = actionTrigger.asActionTrigger
        publishEvents(filter)
            .sink(
                duringLifetimeOf: self,
                receiveValue: { _ in
                    resolvedActionTrigger
                        .applyAnonymous(())
                        .sink(duringLifetimeOf: self)
                }
            )
    }

    func handleEvents(
        _ filter: UIControl.Event,
        _ actionTriggerPublisher: some Publisher<some ActionTriggerConvertible<Self>, Never>
    ) {
        let currentTrigger = Property<ActionTrigger<Self>?>(
            initial: nil,
            then: actionTriggerPublisher.map(\.asActionTrigger)
        )

        publishEvents(filter)
            .sink(
                duringLifetimeOf: self,
                receiveValue: { _ in
                    currentTrigger.value?
                        .applyAnonymous(self)
                        .sink(duringLifetimeOf: self)
                }
            )
    }

    func handleEvents(
        _ filter: UIControl.Event,
        _ actionTriggerPublisher: some Publisher<some ActionTriggerConvertible<Void>, Never>
    ) {
        let currentTrigger = Property<ActionTrigger<Void>?>(
            initial: nil,
            then: actionTriggerPublisher.map(\.asActionTrigger)
        )

        publishEvents(filter)
            .sink(
                duringLifetimeOf: self,
                receiveValue: { _ in
                    currentTrigger.value?
                        .applyAnonymous(())
                        .sink(duringLifetimeOf: self)
                }
            )
    }

    func handleEvents<Input>(
        _ filter: UIControl.Event,
        _ actionTrigger: some ActionTriggerConvertible<Input>,
        _ transform: @escaping (Self) -> Input
    ) {
        let resolvedActionTrigger = actionTrigger.asActionTrigger
        publishEvents(filter)
            .sink(
                duringLifetimeOf: self,
                receiveValue: { _ in
                    resolvedActionTrigger
                        .applyAnonymous(transform(self))
                        .sink(duringLifetimeOf: self)
                }
            )
    }

    func handleEvents<Input>(
        _ filter: UIControl.Event,
        _ actionTriggerPublisher: some Publisher<some ActionTriggerConvertible<Input>, Never>,
        _ transform: @escaping (Self) -> Input
    ) {
        let currentTrigger = Property<ActionTrigger<Input>?>(
            initial: nil,
            then: actionTriggerPublisher.map(\.asActionTrigger)
        )

        publishEvents(filter)
            .sink(
                duringLifetimeOf: self,
                receiveValue: { _ in
                    currentTrigger.value?
                        .applyAnonymous(transform(self))
                        .sink(duringLifetimeOf: self)
                }
            )
    }
}

extension UIControl: _MortarUIControlEventsProviding {}

#endif
