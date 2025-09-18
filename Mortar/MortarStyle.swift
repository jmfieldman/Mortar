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

private class AttributeContainerBox {
    var attributeContainer: AttributeContainer

    init(attributeContainer: AttributeContainer) {
        self.attributeContainer = attributeContainer
    }
}

@MainActor public protocol MortarTextStylable: MortarView {
    var textStyle: AttributeContainer { get set }
}

private extension MortarTextStylable {
    private var attributeContainerBox: AttributeContainerBox {
        if let existing = objc_getAssociatedObject(self, &kStyleBoxAssociationKey) as? AttributeContainerBox {
            return existing
        }

        let newValue = AttributeContainerBox(attributeContainer: .init())
        objc_setAssociatedObject(self, &kStyleBoxAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return newValue
    }
}

public extension MortarTextStylable {
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

extension UILabel: MortarTextStylable {
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

extension UIButton: MortarTextStylable {
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
