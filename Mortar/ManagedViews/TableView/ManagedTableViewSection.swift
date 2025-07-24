//
//  ManagedTableViewSection.swift
//  Copyright © 2025 Jason Fieldman.
//

public struct ManagedTableViewSection {
    public let header: (any ManagedTableViewHeaderFooterViewModel)?
    public let rows: [any ManagedTableViewCellModel]
    public let footer: (any ManagedTableViewHeaderFooterViewModel)?

    public init(
        header: (any ManagedTableViewHeaderFooterViewModel)? = nil,
        rows: [any ManagedTableViewCellModel],
        footer: (any ManagedTableViewHeaderFooterViewModel)? = nil
    ) {
        self.header = header
        self.rows = rows
        self.footer = footer
    }
}
