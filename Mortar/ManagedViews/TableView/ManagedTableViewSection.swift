//
//  ManagedTableViewSection.swift
//  Copyright © 2025 Jason Fieldman.
//

#if os(iOS) || os(tvOS)

public struct ManagedTableViewSection: Identifiable {
    public let id: String
    public let header: (any ManagedTableViewHeaderFooterViewModel)?
    public let rows: [any ManagedTableViewCellModel]
    public let footer: (any ManagedTableViewHeaderFooterViewModel)?

    public init(
        id: String = UUID().uuidString,
        header: (any ManagedTableViewHeaderFooterViewModel)? = nil,
        rows: [any ManagedTableViewCellModel],
        footer: (any ManagedTableViewHeaderFooterViewModel)? = nil
    ) {
        self.id = id
        self.header = header
        self.rows = rows
        self.footer = footer
    }
}

#endif
