//
//  MortarAxisPriorities.swift
//  Copyright © 2025 Jason Fieldman.
//

public struct MortarAxisPriorities {
    public var horizontal: MortarAliasLayoutPriority
    public var vertical: MortarAliasLayoutPriority

    public init(
        horizontal: MortarAliasLayoutPriority,
        vertical: MortarAliasLayoutPriority
    ) {
        self.horizontal = horizontal
        self.vertical = vertical
    }
}

public extension MortarView {
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

    var compressionResistanceHorizontal: MortarAliasLayoutPriority {
        get {
            contentCompressionResistancePriority(for: .horizontal)
        }
        set {
            setContentCompressionResistancePriority(newValue, for: .horizontal)
        }
    }

    var compressionResistanceVertical: MortarAliasLayoutPriority {
        get {
            contentCompressionResistancePriority(for: .vertical)
        }
        set {
            setContentCompressionResistancePriority(newValue, for: .vertical)
        }
    }

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

    var contentHughingHorizontal: MortarAliasLayoutPriority {
        get {
            contentHuggingPriority(for: .horizontal)
        }
        set {
            setContentHuggingPriority(newValue, for: .horizontal)
        }
    }

    var contentHuggingVertical: MortarAliasLayoutPriority {
        get {
            contentHuggingPriority(for: .vertical)
        }
        set {
            setContentHuggingPriority(newValue, for: .vertical)
        }
    }
}
