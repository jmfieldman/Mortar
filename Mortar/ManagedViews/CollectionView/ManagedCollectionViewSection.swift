//
//  ManagedCollectionViewSection.swift
//  Copyright © 2025 Jason Fieldman.
//

#if os(iOS) || os(tvOS)

public struct ManagedCollectionViewSection {
    public let header: (any ManagedCollectionReusableViewModel)?
    public let items: [any ManagedCollectionViewCellModel]
    public let footer: (any ManagedCollectionReusableViewModel)?

    public init(
        header: (any ManagedCollectionReusableViewModel)? = nil,
        items: [any ManagedCollectionViewCellModel],
        footer: (any ManagedCollectionReusableViewModel)? = nil
    ) {
        self.header = header
        self.items = items
        self.footer = footer
    }
}

#endif
