//
//  ManagedTableViewCell.swift
//  Copyright © 2025 Jason Fieldman.
//

#if os(iOS) || os(tvOS)

import CombineEx
import UIKit

public protocol ManagedTableViewCellModel: Identifiable<String> {
    associatedtype Cell: ManagedTableViewCell
    var onSelect: ((ManagedTableView, IndexPath) -> Void)? { get }
    var preventHeightCaching: Bool { get }
}

public extension ManagedTableViewCellModel {
    var onSelect: ((ManagedTableView, IndexPath) -> Void)? { nil }
    var preventHeightCaching: Bool { false }
}

public protocol ManagedTableViewCell: UITableViewCell {
    associatedtype Model: ManagedTableViewCellModel

    /// This function must be implemented by `ManagedTableViewCell` classes.
    /// It is guaranteed to be called only once, on the main thread, *after*
    /// the very first time the model was updated. The `model` property will
    /// be ready for use, and guaranteed to have the first Model value immediately
    /// available.
    @MainActor func configureView()
}

extension ManagedTableViewCell {
    @MainActor func update(model: Model) {
        var created = false
        __AssociatedMutableProperty(self, Model.self, model, &created).value = model
        if created {
            configureView()
        }
    }

    public var model: Property<Model> {
        __AssociatedProperty(self, Model.self)
    }
}

#endif
