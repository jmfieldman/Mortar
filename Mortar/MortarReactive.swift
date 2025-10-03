//
//  MortarReactive.swift
//  Copyright © 2025 Jason Fieldman.
//

import CombineEx

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
