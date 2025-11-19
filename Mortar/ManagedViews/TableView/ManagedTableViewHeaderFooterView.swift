//
//  ManagedTableViewHeaderFooterView.swift
//  Copyright © 2025 Jason Fieldman.
//

#if os(iOS) || os(tvOS)

import UIKit

public protocol ManagedTableViewHeaderFooterViewModel {
    associatedtype Header: ManagedTableViewHeaderFooterView
}

public protocol ManagedTableViewHeaderFooterView: UITableViewHeaderFooterView {
    associatedtype Model: ManagedTableViewHeaderFooterViewModel

    /// This function must be implemented by `ManagedTableViewHeaderFooterView` classes.
    /// It is guaranteed to be called only once, on the main thread, *after*
    /// the very first time the model was updated. The `model` property will
    /// be ready for use, and guaranteed to have the first Model value immediately
    /// available.
    @MainActor func configureView()
}

extension ManagedTableViewHeaderFooterView {
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
