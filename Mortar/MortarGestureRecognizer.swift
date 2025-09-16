//
//  MortarGestureRecognizer.swift
//  Copyright © 2025 Jason Fieldman.
//

import CombineEx

public extension MortarGestureRecognizer {
    convenience init(configuration: (Self) -> Void) {
        self.init(target: nil, action: nil)
        configuration(self)
    }

    func configure(_ configBlock: (Self) -> Void) -> Self {
        configBlock(self)
        return self
    }

    func handleAction(_ actionHandler: @escaping (Self) -> Void) -> Self {
        let typedActionHandler: (MortarGestureRecognizer) -> Void = {
            actionHandler($0 as! Self)
        }

        let target = MortarGestureRecognizerTarget(actionHandler: typedActionHandler)
        addTarget(target, action: #selector(MortarGestureRecognizerTarget.handleGesture))
        permanentlyAssociate(target)
        return self
    }

    func handleDelegation(_ configureBlock: (MortarGestureRecognizerDelegateHandler<Self>) -> Void) -> Self {
        let delegateHandler = MortarGestureRecognizerDelegateHandler<Self>()
        delegate = delegateHandler
        configureBlock(delegateHandler)
        permanentlyAssociate(delegateHandler)
        return self
    }
}

@MainActor
private final class MortarGestureRecognizerTarget: NSObject {
    let actionHandler: (MortarGestureRecognizer) -> Void

    init(actionHandler: @escaping (MortarGestureRecognizer) -> Void) {
        self.actionHandler = actionHandler
    }

    @objc public func handleGesture(_ gestureRecognizer: MortarGestureRecognizer) {
        actionHandler(gestureRecognizer)
    }
}

@MainActor
public final class MortarGestureRecognizerDelegateHandler<T: MortarGestureRecognizer>: NSObject, MortarGestureRecognizerDelegate {
    // Public-configurable handlers

    @available(iOS 17.0, tvOS 17.0, *)
    public var shouldBegin: ((T) -> Bool)? = nil

    @available(iOS 17.0, tvOS 17.0, *)
    public var shouldRecognizeSimultaneouslyWithOther: ((UIGestureRecognizer) -> Bool)? = nil

    @available(iOS 17.0, tvOS 17.0, *)
    public var shouldRequireFailureOfOther: ((UIGestureRecognizer) -> Bool)? = nil

    @available(iOS 17.0, tvOS 17.0, *)
    public var shouldBeRequiredToFailByOther: ((UIGestureRecognizer) -> Bool)? = nil

    @available(iOS 17.0, tvOS 17.0, *)
    public var shouldReceiveTouch: ((UITouch) -> Bool)? = nil

    @available(iOS 17.0, tvOS 17.0, *)
    public var shouldReceivePress: ((UIPress) -> Bool)? = nil

    @available(iOS 17.0, tvOS 17.0, *)
    public var shouldReceiveEvent: ((UIEvent) -> Bool)? = nil

    // Delegate Implementation

    @available(iOS 17.0, tvOS 17.0, *)
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        shouldBegin?(gestureRecognizer as! T) ?? true
    }

    @available(iOS 17.0, tvOS 17.0, *)
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        shouldRecognizeSimultaneouslyWithOther?(otherGestureRecognizer) ?? false
    }

    @available(iOS 17.0, tvOS 17.0, *)
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        shouldRequireFailureOfOther?(otherGestureRecognizer) ?? false
    }

    @available(iOS 17.0, tvOS 17.0, *)
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        shouldBeRequiredToFailByOther?(otherGestureRecognizer) ?? false
    }

    @available(iOS 17.0, tvOS 17.0, *)
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        shouldReceiveTouch?(touch) ?? true
    }

    @available(iOS 17.0, tvOS 17.0, *)
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool {
        shouldReceivePress?(press) ?? true
    }

    @available(iOS 17.0, tvOS 17.0, *)
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive event: UIEvent) -> Bool {
        shouldReceiveEvent?(event) ?? true
    }
}
