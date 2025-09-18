//
//  MortarViewAliases.swift
//  Copyright © 2025 Jason Fieldman.
//

#if os(iOS) || os(tvOS)

/// A type alias for UIContainer pointing to MortarView. `UIContainer` is more
/// descriptive of what container views do vs. SwiftUI's `ZStack`
public typealias UIContainer = MortarView

/// A horizontal stack view that arranges its subviews in a horizontal line.
public class UIHStack: MortarStackView {
    /// Initializes an instance of UIHStack with a specified frame.
    ///
    /// - Parameter frame: The frame rectangle for the view, measured in points.
    override public init(frame: CGRect) {
        super.init(frame: frame)
        axis = .horizontal
    }

    /// This initializer is unavailable and will always cause a runtime error if called.
    ///
    /// - Parameter coder: An NSCoder object that you use to decode your archived data.
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// A vertical stack view that arranges its subviews in a vertical line.
public class UIVStack: MortarStackView {
    /// Initializes an instance of UIVStack with a specified frame.
    ///
    /// - Parameter frame: The frame rectangle for the view, measured in points.
    override public init(frame: CGRect) {
        super.init(frame: frame)
        axis = .vertical
    }

    /// This initializer is unavailable and will always cause a runtime error if called.
    ///
    /// - Parameter coder: An NSCoder object that you use to decode your archived data.
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#endif
