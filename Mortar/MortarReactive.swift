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

public protocol _MortarBindProviding: NSObject {
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

extension NSObject: _MortarBindProviding {}

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

private var kBindingAssociationKey = 0

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

    @discardableResult
    func sink<Binder, E: Error>(
        _ publisher: any Publisher<Void, E>,
        receiveValue: ((Binder) -> Void)?,
        receiveCompletion: ((Binder, Subscribers.Completion<E>) -> Void)?
    ) -> AnyCancellable where Binder == Self

    @discardableResult
    func sink<Binder>(
        _ publisher: any Publisher<Void, Never>,
        receiveValue: ((Binder) -> Void)?
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

    @discardableResult
    func sink<Binder, E: Error>(
        _ publisher: any Publisher<Void, E>,
        receiveValue: ((Binder) -> Void)?,
        receiveCompletion: ((Binder, Subscribers.Completion<E>) -> Void)?
    ) -> AnyCancellable where Binder == Self {
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
    func sink<Binder>(
        _ publisher: any Publisher<Void, Never>,
        receiveValue: ((Binder) -> Void)?
    ) -> AnyCancellable where Binder == Self {
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

public protocol _MortarKVOPropertyProviding: NSObject {
    func kvoProperty<Source, T>(
        _ keyPath: KeyPath<Source, T>
    ) -> Property<T> where Source == Self
}

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

public protocol _MortarUIControlEventsProviding: UIControl {
    func publishEvents<UIControlSubtype>(
        _ filter: UIControl.Event
    ) -> AnyPublisher<UIControlSubtype, Never> where UIControlSubtype == Self

    func handleEvents<UIControlSubtype>(
        _ filter: UIControl.Event,
        _ handleBlock: @escaping (UIControlSubtype) -> Void
    ) where UIControlSubtype == Self

    func handleEvents<UIControlSubtype>(
        _ filter: UIControl.Event,
        _ actionTrigger: some ActionTriggerConvertible<UIControlSubtype>
    ) where UIControlSubtype == Self

    func handleEvents(
        _ filter: UIControl.Event,
        _ actionTrigger: some ActionTriggerConvertible<Void>
    )

    func handleEvents<UIControlSubtype>(
        _ filter: UIControl.Event,
        _ actionTriggerPublisher: some Publisher<some ActionTriggerConvertible<UIControlSubtype>, Never>
    ) where UIControlSubtype == Self

    func handleEvents(
        _ filter: UIControl.Event,
        _ actionTriggerPublisher: some Publisher<some ActionTriggerConvertible<Void>, Never>
    )

    func handleEvents<UIControlSubtype, Input>(
        _ filter: UIControl.Event,
        _ actionTrigger: some ActionTriggerConvertible<Input>,
        _ transform: @escaping (UIControlSubtype) -> Input
    ) where UIControlSubtype == Self

    func handleEvents<UIControlSubtype, Input>(
        _ filter: UIControl.Event,
        _ actionTriggerPublisher: some Publisher<some ActionTriggerConvertible<Input>, Never>,
        _ transform: @escaping (UIControlSubtype) -> Input
    ) where UIControlSubtype == Self
}

public extension _MortarUIControlEventsProviding {
    func publishEvents<UIControlSubtype>(
        _ filter: UIControl.Event = [.allEvents]
    ) -> AnyPublisher<UIControlSubtype, Never> where UIControlSubtype == Self {
        let internalTarget = TargetBox<Self>()
        permanentlyAssociate(internalTarget)
        addTarget(internalTarget, action: #selector(TargetBox<Self>.invoke(sender:)), for: filter)
        return internalTarget.subject.eraseToAnyPublisher()
    }

    func handleEvents<UIControlSubtype>(
        _ filter: UIControl.Event,
        _ handleBlock: @escaping (UIControlSubtype) -> Void
    ) where UIControlSubtype == Self {
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

    func handleEvents<UIControlSubtype>(
        _ filter: UIControl.Event,
        _ actionTriggerPublisher: some Publisher<some ActionTriggerConvertible<UIControlSubtype>, Never>
    ) where UIControlSubtype == Self {
        let currentTrigger = Property<ActionTrigger<UIControlSubtype>?>(
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

    func handleEvents<UIControlSubtype, Input>(
        _ filter: UIControl.Event,
        _ actionTrigger: some ActionTriggerConvertible<Input>,
        _ transform: @escaping (UIControlSubtype) -> Input
    ) where UIControlSubtype == Self {
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

    func handleEvents<UIControlSubtype, Input>(
        _ filter: UIControl.Event,
        _ actionTriggerPublisher: some Publisher<some ActionTriggerConvertible<Input>, Never>,
        _ transform: @escaping (UIControlSubtype) -> Input
    ) where UIControlSubtype == Self {
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
