//
//  ManagedCollectionViewSection.swift
//  Copyright © 2025 Jason Fieldman.
//

#if os(iOS) || os(tvOS)

public struct ManagedCollectionViewSection: Identifiable {
    public let id: String
    public let header: (any ManagedCollectionReusableViewModel)?
    public let items: [any ManagedCollectionViewCellModel]
    public let footer: (any ManagedCollectionReusableViewModel)?

    public init(
        id: String = UUID().uuidString,
        header: (any ManagedCollectionReusableViewModel)? = nil,
        items: [any ManagedCollectionViewCellModel],
        footer: (any ManagedCollectionReusableViewModel)? = nil
    ) {
        self.id = id
        self.header = header
        self.items = items
        self.footer = footer
    }
}

#endif
