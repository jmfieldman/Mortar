//
//  ManagedViewCommon.swift
//  Copyright © 2025 Jason Fieldman.
//

import Foundation
import UIKit

// MARK: ArbitrarilyIdentifiable

/// Managed models can conform to `ArbitrarilyIdentifiable` to provide arbitrary
/// `id` values. This is useful for models of non-collection-esque data such as
/// settings screens.
public protocol ArbitrarilyIdentifiable: Identifiable {}

public extension ArbitrarilyIdentifiable {
    var id: UUID { UUID() }
}

// MARK: Reusable

/// This internal protocol automates reuse identification for managed cells
/// so that they simply use their class name as the reuse identifier.
protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}

extension UITableViewHeaderFooterView: Reusable {}
extension UITableViewCell: Reusable {}
