//
//  View+ResultBuilder.swift
//  Copyright © 2025 Jason Fieldman.
//

public struct MortarAddViewBox {
    /// The view to be added.
    let view: MortarView?
}

@resultBuilder
public struct MortarAddSubviewsBuilder {
    /// Builds an expression from a `MortarView?`.
    /// - Parameter expression: The view to be added.
    /// - Returns: A `MortarAddViewBox` containing the provided view.
    public static func buildExpression(_ expression: MortarView?) -> MortarAddViewBox {
        MortarAddViewBox(view: expression)
    }

    /// Builds an expression from a `Void`.
    /// - Parameter expression: A void value.
    /// - Returns: A `MortarAddViewBox` with a nil view.
    public static func buildExpression(_ expression: Void) -> MortarAddViewBox {
        MortarAddViewBox(view: nil)
    }

    /// Builds an expression from a `MortarConstraintGroup`.
    /// - Parameter expression: A MortarConstraintGroup value.
    /// - Returns: A `MortarAddViewBox` with a nil view.
    public static func buildExpression(_ expression: MortarConstraintGroup) -> MortarAddViewBox {
        MortarAddViewBox(view: nil)
    }

    /// Builds a block from multiple `MortarAddViewBox` components.
    /// - Parameter components: An array of `MortarAddViewBox` components.
    /// - Returns: An array of `MortarAddViewBox` components.
    public static func buildBlock(_ components: MortarAddViewBox...) -> [MortarAddViewBox] {
        components
    }
}

public extension MortarView {
    /// Adds subviews to the current view using a result builder.
    /// - Parameter subviewBoxes: A closure that returns an array of `MortarAddViewBox` instances.
    func addSubviews(@MortarAddSubviewsBuilder _ subviewBoxes: () -> [MortarAddViewBox]) {
        MortarMainThreadLayoutStack.execute {
            process(subviewBoxes())
        }
    }
}

public extension MortarView {
    /// Initializes a `MortarView` with subviews using a result builder.
    /// - Parameter subviewBoxes: A closure that returns an array of `MortarAddViewBox` instances.
    convenience init(@MortarAddSubviewsBuilder _ subviewBoxes: () -> [MortarAddViewBox]) {
        self.init(frame: .zero)
        MortarMainThreadLayoutStack.execute {
            process(subviewBoxes())
        }
    }

    /// Initializes a `MortarView` with subviews using a result builder, allowing the view to be referenced in the closure.
    /// - Parameter subviewBoxes: A closure that takes the current view and returns an array of `MortarAddViewBox` instances.
    convenience init(@MortarAddSubviewsBuilder _ subviewBoxes: (MortarView) -> [MortarAddViewBox]) {
        self.init(frame: .zero)
        MortarMainThreadLayoutStack.execute {
            process(subviewBoxes(self))
        }
    }
}

private extension MortarView {
    /// Processes an array of `MortarAddViewBox` instances and adds their views to the current view.
    /// - Parameter addViewBoxes: An array of `MortarAddViewBox` instances.
    func process(_ addViewBoxes: [MortarAddViewBox]) {
        if let stackView = self as? MortarStackView {
            addViewBoxes.compactMap(\.view).forEach { stackView.addArrangedSubview($0) }
        } else {
            addViewBoxes.compactMap(\.view).forEach(addSubview)
        }
    }
}
