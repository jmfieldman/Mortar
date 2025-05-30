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

    /// Builds an expression from a `AnyCancellable`.
    /// - Parameter expression: An AnyCancellable value.
    /// - Returns: A `MortarAddViewBox` with a nil view.
    public static func buildExpression(_ expression: AnyCancellable) -> MortarAddViewBox {
        MortarAddViewBox(view: nil)
    }

    /// Builds a block from multiple `MortarAddViewBox` components.
    /// - Parameter components: An array of `MortarAddViewBox` components.
    /// - Returns: An array of `MortarAddViewBox` components.
    public static func buildBlock(_ components: MortarAddViewBox...) -> [MortarAddViewBox] {
        components
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

public protocol MortarFrameInitializable {
    init(frame: CGRect)
}

extension MortarView: MortarFrameInitializable {}

public extension MortarFrameInitializable where Self: MortarView {
    /// Initializes a `MortarView` with subviews using a result builder.
    /// - Parameter subviewBoxes: A closure that returns an array of `MortarAddViewBox` instances.
    init(@MortarAddSubviewsBuilder _ subviewBoxes: () -> [MortarAddViewBox]) {
        self.init(frame: .zero)
        MortarMainThreadLayoutStack.execute {
            process(subviewBoxes())
        }
    }

    /// Initializes a `MortarView` with subviews using a result builder, allowing the view to be referenced in the closure.
    /// - Parameter subviewBoxes: A closure that takes the current view and returns an array of `MortarAddViewBox` instances.
    init(@MortarAddSubviewsBuilder _ subviewBoxes: (Self) -> [MortarAddViewBox]) {
        self.init(frame: .zero)
        MortarMainThreadLayoutStack.execute {
            process(subviewBoxes(self))
        }
    }
}

public protocol MortarConfigurableView {}

extension MortarView: MortarConfigurableView {}

public extension MortarConfigurableView where Self: MortarView {
    /// Configures the view by adding subviews using a result builder.
    /// - Parameter configureBlock: A closure that returns an array of `MortarAddViewBox` instances.
    /// - Returns: The configured view (`Self`).
    @discardableResult
    func configure(@MortarAddSubviewsBuilder _ configureBlock: () -> [MortarAddViewBox]) -> Self {
        MortarMainThreadLayoutStack.execute {
            process(configureBlock())
        }
        return self
    }

    /// Configures the view by adding subviews using a result builder, allowing access to the view within the closure.
    /// - Parameter configureBlock: A closure that takes `Self` and returns an array of `MortarAddViewBox` instances.
    /// - Returns: The configured view (`Self`).
    @discardableResult
    func configure(@MortarAddSubviewsBuilder _ configureBlock: (Self) -> [MortarAddViewBox]) -> Self {
        MortarMainThreadLayoutStack.execute {
            process(configureBlock(self))
        }
        return self
    }
}
