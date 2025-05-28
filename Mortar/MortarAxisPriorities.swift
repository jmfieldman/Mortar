//
//  MortarAxisPriorities.swift
//  Copyright © 2025 Jason Fieldman.
//

/// Represents the layout priorities for both horizontal and vertical axes.
public struct MortarAxisPriorities {
    /// The horizontal layout priority.
    public var horizontal: MortarAliasLayoutPriority

    /// The vertical layout priority.
    public var vertical: MortarAliasLayoutPriority

    /// Initializes the priorities with specified horizontal and vertical values.
    /// - Parameters:
    ///   - horizontal: The horizontal layout priority.
    ///   - vertical: The vertical layout priority.
    public init(
        horizontal: MortarAliasLayoutPriority,
        vertical: MortarAliasLayoutPriority
    ) {
        self.horizontal = horizontal
        self.vertical = vertical
    }
}

public extension MortarView {
    /// Gets or sets the compression resistance priorities for both horizontal and vertical axes.
    var compressionResistance: MortarAxisPriorities {
        get {
            .init(
                horizontal: contentCompressionResistancePriority(for: .horizontal),
                vertical: contentCompressionResistancePriority(for: .vertical)
            )
        }
        set {
            setContentCompressionResistancePriority(newValue.horizontal, for: .horizontal)
            setContentCompressionResistancePriority(newValue.vertical, for: .vertical)
        }
    }

    /// Gets or sets the horizontal compression resistance priority.
    var compressionResistanceHorizontal: MortarAliasLayoutPriority {
        get {
            contentCompressionResistancePriority(for: .horizontal)
        }
        set {
            setContentCompressionResistancePriority(newValue, for: .horizontal)
        }
    }

    /// Gets or sets the vertical compression resistance priority.
    var compressionResistanceVertical: MortarAliasLayoutPriority {
        get {
            contentCompressionResistancePriority(for: .vertical)
        }
        set {
            setContentCompressionResistancePriority(newValue, for: .vertical)
        }
    }

    /// Gets or sets the content hugging priorities for both horizontal and vertical axes.
    var contentHugging: MortarAxisPriorities {
        get {
            .init(
                horizontal: contentHuggingPriority(for: .horizontal),
                vertical: contentHuggingPriority(for: .vertical)
            )
        }
        set {
            setContentHuggingPriority(newValue.horizontal, for: .horizontal)
            setContentHuggingPriority(newValue.vertical, for: .vertical)
        }
    }

    /// Gets or sets the horizontal content hugging priority.
    var contentHuggingHorizontal: MortarAliasLayoutPriority {
        get {
            contentHuggingPriority(for: .horizontal)
        }
        set {
            setContentHuggingPriority(newValue, for: .horizontal)
        }
    }

    /// Gets or sets the vertical content hugging priority.
    var contentHuggingVertical: MortarAliasLayoutPriority {
        get {
            contentHuggingPriority(for: .vertical)
        }
        set {
            setContentHuggingPriority(newValue, for: .vertical)
        }
    }
}
