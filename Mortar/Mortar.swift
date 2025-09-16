//
//  Mortar.swift
//  Copyright © 2016 Jason Fieldman.
//

#if os(iOS) || os(tvOS)
import UIKit

public typealias MortarView = UIView
public typealias MortarStackView = UIStackView
public typealias MortarLayoutGuide = UILayoutGuide
public typealias MortarEdgeInsets = UIEdgeInsets
public typealias MortarAliasLayoutPriority = UILayoutPriority
public typealias MortarAliasLayoutRelation = NSLayoutConstraint.Relation
public typealias MortarAliasLayoutAttribute = NSLayoutConstraint.Attribute
public typealias MortarAliasLayoutAxis = NSLayoutConstraint.Axis
public typealias MortarGestureRecognizer = UIGestureRecognizer
public typealias MortarGestureRecognizerDelegate = UIGestureRecognizerDelegate
#else
import AppKit

public typealias MortarView = NSView
public typealias MortarStackView = NSStackView
public typealias MortarLayoutGuide = NSLayoutGuide
public typealias MortarEdgeInsets = NSEdgeInsets
public typealias MortarAliasLayoutPriority = NSLayoutConstraint.Priority
public typealias MortarAliasLayoutRelation = NSLayoutConstraint.Relation
public typealias MortarAliasLayoutAttribute = NSLayoutConstraint.Attribute
public typealias MortarAliasLayoutAxis = NSLayoutConstraint.Orientation
public typealias MortarGestureRecognizer = NSGestureRecognizer
public typealias MortarGestureRecognizerDelegate = NSGestureRecognizerDelegate
#endif

public enum MortarActivationState {
    case activated, deactivated
}

/// Defines the virtual Mortar-specific attributes, which allow for custom
/// attributes that represent multuple sub-attributes.
enum MortarLayoutAttribute {
    enum LayoutType {
        case position, size
    }

    /// How many sub-attributes exist in this attribute
    var degree: Int { componentAttributes.count }

    // Standard attributes
    case left
    case right
    case top
    case bottom
    case leading
    case trailing
    case width
    case height
    case centerX
    case centerY
    case baseline
    case firstBaseline
    case lastBaseline
    case notAnAttribute

    // iOS/tvOS-specific attributes
    #if os(iOS) || os(tvOS)
    case leftMargin
    case rightMargin
    case topMargin
    case bottomMargin
    case leadingMargin
    case trailingMargin
    case centerXWithinMargins
    case centerYWithinMargins
    case sideMargins
    case capMargins
    #endif

    // Attributes with multiple sub-attributes
    case sides
    case caps
    case size
    case topLeft
    case topLeading
    case topRight
    case topTrailing
    case bottomLeft
    case bottomLeading
    case bottomRight
    case bottomTrailing
    case edges
    case center

    #if os(iOS) || os(tvOS)
    static func from(_ standardAttribute: MortarAliasLayoutAttribute) -> MortarLayoutAttribute {
        switch standardAttribute {
        case .left: return .left
        case .right: return .right
        case .top: return .top
        case .bottom: return .bottom
        case .leading: return .leading
        case .trailing: return .trailing
        case .width: return .width
        case .height: return .height
        case .centerX: return .centerX
        case .centerY: return .centerY
        case .lastBaseline: return .lastBaseline
        case .firstBaseline: return .firstBaseline
        case .leftMargin: return .leftMargin
        case .rightMargin: return .rightMargin
        case .topMargin: return .topMargin
        case .bottomMargin: return .bottomMargin
        case .leadingMargin: return .leadingMargin
        case .trailingMargin: return .trailingMargin
        case .centerXWithinMargins: return .centerXWithinMargins
        case .centerYWithinMargins: return .centerYWithinMargins
        case .notAnAttribute: return .notAnAttribute
        @unknown default:
            return .notAnAttribute
        }
    }
    #else
    static func from(_ standardAttribute: MortarAliasLayoutAttribute) -> MortarLayoutAttribute {
        switch standardAttribute {
        case .left: return .left
        case .right: return .right
        case .top: return .top
        case .bottom: return .bottom
        case .leading: return .leading
        case .trailing: return .trailing
        case .width: return .width
        case .height: return .height
        case .centerX: return .centerX
        case .centerY: return .centerY
        @unknown default:
            return .notAnAttribute
        }
    }
    #endif

    #if os(iOS) || os(tvOS)
    var standardLayoutAttribute: MortarAliasLayoutAttribute? {
        switch self {
        case .left: .left
        case .right: .right
        case .top: .top
        case .bottom: .bottom
        case .leading: .leading
        case .trailing: .trailing
        case .width: .width
        case .height: .height
        case .centerX: .centerX
        case .centerY: .centerY
        case .baseline: .lastBaseline
        case .firstBaseline: .firstBaseline
        case .lastBaseline: .lastBaseline
        case .leftMargin: .leftMargin
        case .rightMargin: .rightMargin
        case .topMargin: .topMargin
        case .bottomMargin: .bottomMargin
        case .leadingMargin: .leadingMargin
        case .trailingMargin: .trailingMargin
        case .centerXWithinMargins: .centerXWithinMargins
        case .centerYWithinMargins: .centerYWithinMargins
        case .notAnAttribute: .notAnAttribute
        default: nil
        }
    }
    #else
    var standardLayoutAttribute: MortarAliasLayoutAttribute? {
        switch self {
        case .left: .left
        case .right: .right
        case .top: .top
        case .bottom: .bottom
        case .leading: .leading
        case .trailing: .trailing
        case .width: .width
        case .height: .height
        case .centerX: .centerX
        case .centerY: .centerY
        case .baseline: .lastBaseline
        case .firstBaseline: .firstBaseline
        case .lastBaseline: .lastBaseline
        case .notAnAttribute: .notAnAttribute
        default: nil
        }
    }
    #endif

    #if os(iOS) || os(tvOS)
    var axis: MortarAliasLayoutAxis? {
        switch self {
        case .left: .horizontal
        case .right: .horizontal
        case .top: .vertical
        case .bottom: .vertical
        case .leading: .horizontal
        case .trailing: .horizontal
        case .width: .horizontal
        case .height: .vertical
        case .centerX: .horizontal
        case .centerY: .vertical
        case .baseline: .vertical
        case .firstBaseline: .vertical
        case .lastBaseline: .vertical
        case .leftMargin: .horizontal
        case .rightMargin: .horizontal
        case .topMargin: .vertical
        case .bottomMargin: .vertical
        case .leadingMargin: .horizontal
        case .trailingMargin: .horizontal
        case .centerXWithinMargins: .horizontal
        case .centerYWithinMargins: .vertical
        case .sideMargins: .horizontal
        case .capMargins: .vertical
        default: nil
        }
    }
    #else
    var axis: MortarAxis? {
        switch self {
        case .left: .horizontal
        case .right: .horizontal
        case .top: .vertical
        case .bottom: .vertical
        case .leading: .horizontal
        case .trailing: .horizontal
        case .width: .horizontal
        case .height: .vertical
        case .centerX: .horizontal
        case .centerY: .vertical
        case .baseline: .vertical
        case .firstBaseline: .vertical
        case .lastBaseline: .vertical
        default: nil
        }
    }
    #endif

    #if os(iOS) || os(tvOS)
    var layoutType: LayoutType? {
        switch self {
        case .left: .position
        case .right: .position
        case .top: .position
        case .bottom: .position
        case .leading: .position
        case .trailing: .position
        case .width: .size
        case .height: .size
        case .centerX: .position
        case .centerY: .position
        case .baseline: .position
        case .firstBaseline: .position
        case .lastBaseline: .position
        case .leftMargin: .position
        case .rightMargin: .position
        case .topMargin: .position
        case .bottomMargin: .position
        case .leadingMargin: .position
        case .trailingMargin: .position
        case .centerXWithinMargins: .position
        case .centerYWithinMargins: .position
        case .sideMargins: .position
        case .capMargins: .position
        default: nil
        }
    }
    #else
    var layoutType: LayoutType? {
        switch self {
        case .left: .position
        case .right: .position
        case .top: .position
        case .bottom: .position
        case .leading: .position
        case .trailing: .position
        case .width: .size
        case .height: .size
        case .centerX: .position
        case .centerY: .position
        case .baseline: .position
        case .firstBaseline: .position
        case .lastBaseline: .position
        default: nil
        }
    }
    #endif

    #if os(iOS) || os(tvOS)
    var componentAttributes: [MortarAliasLayoutAttribute] {
        switch self {
        case .left: [.left]
        case .right: [.right]
        case .top: [.top]
        case .bottom: [.bottom]
        case .leading: [.leading]
        case .trailing: [.trailing]
        case .width: [.width]
        case .height: [.height]
        case .centerX: [.centerX]
        case .centerY: [.centerY]
        case .baseline: [.lastBaseline]
        case .firstBaseline: [.firstBaseline]
        case .lastBaseline: [.lastBaseline]
        case .leftMargin: [.leftMargin]
        case .rightMargin: [.rightMargin]
        case .topMargin: [.topMargin]
        case .bottomMargin: [.bottomMargin]
        case .leadingMargin: [.leadingMargin]
        case .trailingMargin: [.trailingMargin]
        case .centerXWithinMargins: [.centerXWithinMargins]
        case .centerYWithinMargins: [.centerYWithinMargins]
        case .sideMargins: [.leadingMargin, .trailingMargin]
        case .capMargins: [.topMargin, .bottomMargin]
        case .notAnAttribute: [.notAnAttribute]
        case .sides: [.leading, .trailing]
        case .caps: [.top, .bottom]
        case .size: [.width, .height]
        case .topLeft: [.top, .left]
        case .topLeading: [.top, .leading]
        case .topRight: [.top, .right]
        case .topTrailing: [.top, .trailing]
        case .bottomLeft: [.bottom, .left]
        case .bottomLeading: [.bottom, .leading]
        case .bottomRight: [.bottom, .right]
        case .bottomTrailing: [.bottom, .trailing]
        case .edges: [.top, .leading, .bottom, .trailing]
        case .center: [.centerX, .centerY]
        }
    }
    #else
    var componentAttributes: [MortarAliasLayoutAttribute] {
        switch self {
        case .left: [.left]
        case .right: [.right]
        case .top: [.top]
        case .bottom: [.bottom]
        case .leading: [.leading]
        case .trailing: [.trailing]
        case .width: [.width]
        case .height: [.height]
        case .centerX: [.centerX]
        case .centerY: [.centerY]
        case .baseline: [.baseline]
        case .firstBaseline: [.firstBaseline]
        case .lastBaseline: [.lastBaseline]
        case .notAnAttribute: [.notAnAttribute]
        case .sides: [.leading, .trailing]
        case .caps: [.top, .bottom]
        case .size: [.width, .height]
        case .topLeft: [.top, .left]
        case .topLeading: [.top, .leading]
        case .topRight: [.top, .right]
        case .topTrailing: [.top, .trailing]
        case .bottomLeft: [.bottom, .left]
        case .bottomLeading: [.bottom, .leading]
        case .bottomRight: [.bottom, .right]
        case .bottomTrailing: [.bottom, .trailing]
        case .edges: [.top, .leading, .bottom, .trailing]
        case .center: [.centerX, .centerY]
        }
    }
    #endif
}

public enum MortarLayoutPriority {
    case low, medium, high, required, priority(Int)

    @inline(__always) public func layoutPriority() -> MortarAliasLayoutPriority {
        switch self {
        case .low: MortarAliasLayoutPriority.defaultLow
        case .medium: MortarAliasLayoutPriority(rawValue: (Float(MortarAliasLayoutPriority.defaultHigh.rawValue) + Float(MortarAliasLayoutPriority.defaultLow.rawValue)) / 2)
        case .high: MortarAliasLayoutPriority.defaultHigh
        case .required: MortarAliasLayoutPriority.required
        case let .priority(value): MortarAliasLayoutPriority(rawValue: Float(value))
        }
    }
}
