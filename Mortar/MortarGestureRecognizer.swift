//
//  MortarGestureRecognizer.swift
//  Copyright © 2025 Jason Fieldman.
//

import CombineEx

/// A convenience initializer for creating gesture recognizers with configuration blocks.
public extension MortarGestureRecognizer {
    /// Initializes a gesture recognizer with a configuration block.
    ///
    /// - Parameter configuration: A closure that configures the gesture recognizer.
    convenience init(configuration: (Self) -> Void) {
        self.init(target: nil, action: nil)
        configuration(self)
    }

    /// Configures the gesture recognizer with a block and returns self for chaining.
    ///
    /// - Parameter configBlock: A closure that configures the gesture recognizer.
    /// - Returns: The configured gesture recognizer instance.
    func configure(_ configBlock: (Self) -> Void) -> Self {
        configBlock(self)
        return self
    }

    /// Assigns an action handler to be called when the gesture is recognized.
    ///
    /// - Parameter actionHandler: A closure that handles the gesture recognition event.
    /// - Returns: The configured gesture recognizer instance.
    func handleAction(_ actionHandler: @escaping (Self) -> Void) -> Self {
        let typedActionHandler: (MortarGestureRecognizer) -> Void = {
            actionHandler($0 as! Self)
        }

        let target = MortarGestureRecognizerTarget(actionHandler: typedActionHandler)
        addTarget(target, action: #selector(MortarGestureRecognizerTarget.handleGesture))
        permanentlyAssociate(target)
        return self
    }

    /// Configures the gesture recognizer's delegate with a block.
    ///
    /// - Parameter configureBlock: A closure that configures the gesture recognizer delegate.
    /// - Returns: The configured gesture recognizer instance.
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

    /// Determines whether the gesture recognizer should begin recognizing gestures.
    @available(iOS 17.0, tvOS 17.0, *)
    public var shouldBegin: ((T) -> Bool)? = nil

    /// Determines whether the gesture recognizer should recognize simultaneously with other gesture recognizers.
    @available(iOS 17.0, tvOS 17.0, *)
    public var shouldRecognizeSimultaneouslyWithOther: ((UIGestureRecognizer) -> Bool)? = nil

    /// Determines whether the gesture recognizer should require another gesture recognizer to fail.
    @available(iOS 17.0, tvOS 17.0, *)
    public var shouldRequireFailureOfOther: ((UIGestureRecognizer) -> Bool)? = nil

    /// Determines whether the gesture recognizer should be required to fail by another gesture recognizer.
    @available(iOS 17.0, tvOS 17.0, *)
    public var shouldBeRequiredToFailByOther: ((UIGestureRecognizer) -> Bool)? = nil

    /// Determines whether the gesture recognizer should receive a touch.
    @available(iOS 17.0, tvOS 17.0, *)
    public var shouldReceiveTouch: ((UITouch) -> Bool)? = nil

    /// Determines whether the gesture recognizer should receive a press.
    @available(iOS 17.0, tvOS 17.0, *)
    public var shouldReceivePress: ((UIPress) -> Bool)? = nil

    /// Determines whether the gesture recognizer should receive an event.
    @available(iOS 17.0, tvOS 17.0, *)
    public var shouldReceiveEvent: ((UIEvent) -> Bool)? = nil

    // Delegate Implementation

    /// Determines whether the gesture recognizer should begin recognizing gestures.
    @available(iOS 17.0, tvOS 17.0, *)
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        shouldBegin?(gestureRecognizer as! T) ?? true
    }

    /// Determines whether the gesture recognizer should recognize simultaneously with other gesture recognizers.
    @available(iOS 17.0, tvOS 17.0, *)
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        shouldRecognizeSimultaneouslyWithOther?(otherGestureRecognizer) ?? false
    }

    /// Determines whether the gesture recognizer should require another gesture recognizer to fail.
    @available(iOS 17.0, tvOS 17.0, *)
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        shouldRequireFailureOfOther?(otherGestureRecognizer) ?? false
    }

    /// Determines whether the gesture recognizer should be required to fail by another gesture recognizer.
    @available(iOS 17.0, tvOS 17.0, *)
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        shouldBeRequiredToFailByOther?(otherGestureRecognizer) ?? false
    }

    /// Determines whether the gesture recognizer should receive a touch.
    @available(iOS 17.0, tvOS 17.0, *)
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        shouldReceiveTouch?(touch) ?? true
    }

    /// Determines whether the gesture recognizer should receive a press.
    @available(iOS 17.0, tvOS 17.0, *)
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool {
        shouldReceivePress?(press) ?? true
    }

    /// Determines whether the gesture recognizer should receive an event.
    @available(iOS 17.0, tvOS 17.0, *)
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive event: UIEvent) -> Bool {
        shouldReceiveEvent?(event) ?? true
    }
}
