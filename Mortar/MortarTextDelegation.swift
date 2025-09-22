//
//  MortarTextDelegation.swift
//  Copyright © 2025 Jason Fieldman.
//

#if os(iOS) || os(tvOS)

import CombineEx
import UIKit

@MainActor public protocol MortarExtendableTextField: UITextField {}
extension UITextField: MortarExtendableTextField {}

public extension MortarExtendableTextField {
    /// Configures the UITextField's delegation with a block.
    ///
    /// - Parameter configureBlock: A closure that configures the gesture recognizer delegate.
    /// - Returns: The configured gesture recognizer instance.
    func handleDelegation(_ configureBlock: (MortarTextFieldDelegateHandler<Self>) -> Void) {
        let delegateHandler = MortarTextFieldDelegateHandler<Self>()
        delegate = delegateHandler
        configureBlock(delegateHandler)
        permanentlyAssociate(delegateHandler)
    }
}

@MainActor
public final class MortarTextFieldDelegateHandler<T: MortarExtendableTextField>: NSObject, UITextFieldDelegate {
    // Public-configurable handlers

    @available(iOS 17.0, tvOS 17.0, *)
    public var shouldClear: ((T) -> Bool)? = nil

    @available(iOS 17.0, tvOS 17.0, *)
    public var shouldReturn: ((T) -> Bool)? = nil

    @available(iOS 17.0, tvOS 17.0, *)
    public var didEndEditing: ((T) -> Void)? = nil

    @available(iOS 17.0, tvOS 17.0, *)
    public var didEndEditingWithReason: ((T, UITextField.DidEndEditingReason) -> Void)? = nil

    @available(iOS 17.0, tvOS 17.0, *)
    public var didBeginEditing: ((T) -> Void)? = nil

    @available(iOS 17.0, tvOS 17.0, *)
    public var didChangeSelection: ((T) -> Void)? = nil

    @available(iOS 17.0, tvOS 17.0, *)
    public var shouldEndEditing: ((T) -> Bool)? = nil

    @available(iOS 17.0, tvOS 17.0, *)
    public var shouldBeginEditing: ((T) -> Bool)? = nil

    @available(iOS 17.0, tvOS 17.0, *)
    public var willPresentEditMenu: ((T, UIEditMenuInteractionAnimating) -> Void)? = nil

    @available(iOS 17.0, tvOS 17.0, *)
    public var didPresentEditMenu: ((T, UIEditMenuInteractionAnimating) -> Void)? = nil

    @available(iOS 17.0, tvOS 17.0, *)
    public var shouldChangeCharactersInRange: ((T, NSRange, String) -> Bool)? = nil

    @available(iOS 17.0, tvOS 17.0, *)
    public var shouldChangeCharactersInRanges: ((T, [NSValue], String) -> Bool)? = nil

    @available(iOS 17.0, tvOS 17.0, *)
    public var editMenuForCharactersInRange: ((T, NSRange, [UIMenuElement]) -> UIMenu?)? = nil

    @available(iOS 17.0, tvOS 17.0, *)
    public var editMenuForCharactersInRanges: ((T, [NSValue], [UIMenuElement]) -> UIMenu?)? = nil

    // Delegate Implementation

    @available(iOS 17.0, tvOS 17.0, *)
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        shouldClear?(textField as! T) ?? true
    }

    @available(iOS 17.0, tvOS 17.0, *)
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        shouldReturn?(textField as! T) ?? true
    }

    @available(iOS 17.0, tvOS 17.0, *)
    public func textFieldDidEndEditing(_ textField: UITextField) {
        didEndEditing?(textField as! T)
    }

    @available(iOS 17.0, tvOS 17.0, *)
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        didBeginEditing?(textField as! T)
    }

    @available(iOS 17.0, tvOS 17.0, *)
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        shouldEndEditing?(textField as! T) ?? true
    }

    @available(iOS 17.0, tvOS 17.0, *)
    public func textFieldDidChangeSelection(_ textField: UITextField) {
        didChangeSelection?(textField as! T)
    }

    @available(iOS 17.0, tvOS 17.0, *)
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        shouldBeginEditing?(textField as! T) ?? true
    }

    @available(iOS 17.0, tvOS 17.0, *)
    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        didEndEditingWithReason?(textField as! T, reason)
    }

    @available(iOS 17.0, tvOS 17.0, *)
    public func textField(_ textField: UITextField, willDismissEditMenuWith animator: any UIEditMenuInteractionAnimating) {
        didPresentEditMenu?(textField as! T, animator)
    }

    @available(iOS 17.0, tvOS 17.0, *)
    public func textField(_ textField: UITextField, willPresentEditMenuWith animator: any UIEditMenuInteractionAnimating) {
        willPresentEditMenu?(textField as! T, animator)
    }

    @available(iOS 17.0, tvOS 17.0, *)
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        shouldChangeCharactersInRange?(textField as! T, range, string) ?? true
    }

    @available(iOS 17.0, tvOS 17.0, *)
    public func textField(_ textField: UITextField, shouldChangeCharactersInRanges ranges: [NSValue], replacementString string: String) -> Bool {
        shouldChangeCharactersInRanges?(textField as! T, ranges, string) ?? true
    }

    @available(iOS 17.0, tvOS 17.0, *)
    public func textField(_ textField: UITextField, editMenuForCharactersIn range: NSRange, suggestedActions: [UIMenuElement]) -> UIMenu? {
        editMenuForCharactersInRange?(textField as! T, range, suggestedActions)
    }

    @available(iOS 17.0, tvOS 17.0, *)
    public func textField(_ textField: UITextField, editMenuForCharactersInRanges ranges: [NSValue], suggestedActions: [UIMenuElement]) -> UIMenu? {
        editMenuForCharactersInRanges?(textField as! T, ranges, suggestedActions)
    }
}

#endif
