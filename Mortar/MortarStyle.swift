//
//  MortarStyle.swift
//  Copyright © 2025 Jason Fieldman.
//

#if os(iOS) || os(tvOS)
import UIKit
#else
import AppKit
#endif

private var kStyleBoxAssociationKey = 0

/// A private class that wraps an `AttributeContainer` for use with associated objects.
///
/// This wrapper is used to store and manage text style attributes for views
/// that conform to `MortarTextStylable`.
private class AttributeContainerBox {
    var attributeContainer: AttributeContainer

    init(attributeContainer: AttributeContainer) {
        self.attributeContainer = attributeContainer
    }
}

/// A protocol that defines text styling capabilities for views.
///
/// Conforming types can use the `textStyle` property to get and set
/// text attributes that will be applied to their content.
@MainActor public protocol MortarTextStylable: MortarView {
    var textStyle: AttributeContainer { get set }
}

/// This extension manages the associated object storage for text styles,
/// ensuring that each conforming view has its own attribute container.
private extension MortarTextStylable {
    /// The associated `AttributeContainerBox` for this view.
    ///
    /// This property uses Objective-C's associated object mechanism to store
    /// the text style information for each view that conforms to `MortarTextStylable`.
    private var attributeContainerBox: AttributeContainerBox {
        if let existing = objc_getAssociatedObject(self, &kStyleBoxAssociationKey) as? AttributeContainerBox {
            return existing
        }

        let newValue = AttributeContainerBox(attributeContainer: .init())
        objc_setAssociatedObject(self, &kStyleBoxAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return newValue
    }
}

/// A public extension to `MortarTextStylable` that implements the `textStyle` property.
///
/// This extension provides the actual implementation of the `textStyle` property
/// that allows getting and setting text attributes for conforming views.
public extension MortarTextStylable {
    /// The text style attributes to apply to the view's content.
    ///
    /// When getting, returns the current text style attributes.
    /// When setting, updates the text style attributes for the view.
    var textStyle: AttributeContainer {
        get {
            attributeContainerBox.attributeContainer
        }

        set {
            attributeContainerBox.attributeContainer = newValue
        }
    }
}

#if os(iOS) || os(tvOS)

/// Extension to `UILabel` that makes it conform to `MortarTextStylable`.
///
/// This extension adds support for styled text in UILabel instances,
/// allowing them to use the `styledText` property to set attributed text.
extension UILabel: MortarTextStylable {
    /// The styled text content of the label.
    ///
    /// When getting, returns the current text value.
    /// When setting, applies the text with the current `textStyle` attributes
    /// to create an attributed string.
    public var styledText: String? {
        get {
            text
        }

        set {
            attributedText = newValue.flatMap {
                NSAttributedString(AttributedString($0, attributes: textStyle))
            }
        }
    }
}

/// Extension to `UIButton` that makes it conform to `MortarTextStylable`.
///
/// This extension adds support for styled text in UIButton instances,
/// allowing them to use the `setStyledTitle` method to set attributed titles.
extension UIButton: MortarTextStylable {
    /// Sets the styled title for a button state.
    ///
    /// This method applies the current `textStyle` attributes to the provided title
    /// and sets it as the attributed title for the specified control state.
    ///
    /// - Parameters:
    ///   - title: The title string to apply styling to.
    ///   - state: The control state for which to set the title.
    public func setStyledTitle(_ title: String?, for state: UIControl.State) {
        setAttributedTitle(
            title.flatMap {
                NSAttributedString(AttributedString($0, attributes: textStyle))
            },
            for: state
        )
    }
}

#endif
