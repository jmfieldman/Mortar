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

/// A class that wraps an `[NSAttributedString.Key: Any]` for use with associated
/// objects and allowing the dictionary to be Sendable.
public final class TextStyle: @unchecked Sendable {
    let attributes: [NSAttributedString.Key: Any]

    init(_ attributeDictionary: [NSAttributedString.Key: Any]) {
        self.attributes = attributeDictionary
    }
}

/// A protocol that defines text styling capabilities for views.
///
/// Conforming types can use the `textStyle` property to get and set
/// text attributes that will be applied to their content.
@MainActor public protocol MortarTextStylable: MortarView {
    var textStyle: TextStyle? { get set }
}

/// A public extension to `MortarTextStylable` that implements the `textStyle` property.
public extension MortarTextStylable {
    /// The text style attributes to apply to the view's content.
    var textStyle: TextStyle? {
        get {
            objc_getAssociatedObject(self, &kStyleBoxAssociationKey) as? TextStyle
        }
        set {
            objc_setAssociatedObject(self, &kStyleBoxAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

public extension NSParagraphStyle {
    /// Allows the user to configure a paragraph style inline, e.g.
    ///
    ///   let style: NSParagraphStyle = .configure {
    ///     $0.alignment = .center
    ///   }
    static func configure(_ block: (NSMutableParagraphStyle) -> Void) -> NSMutableParagraphStyle {
        let style = NSMutableParagraphStyle()
        block(style)
        return style
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
                NSAttributedString(string: $0, attributes: textStyle?.attributes)
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
                NSAttributedString(string: $0, attributes: textStyle?.attributes)
            },
            for: state
        )
    }
}

#endif
