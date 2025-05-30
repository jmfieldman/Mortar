//
//  ManagedTableViewHeaderFooterView.swift
//  Copyright © 2025 Jason Fieldman.
//

import UIKit

public protocol ManagedTableViewHeaderFooterViewModel {
    associatedtype Header: ManagedTableViewHeaderFooterView
}

public protocol ManagedTableViewHeaderFooterView: UITableViewHeaderFooterView {
    associatedtype Model: ManagedTableViewHeaderFooterViewModel
}

extension ManagedTableViewHeaderFooterView {
    func update(model: Model) {
        __AssociatedMutableProperty(self, Model.self).value = model
    }

    public var model: AnyPublisher<Model, Never> {
        __AssociatedPublisher(self, Model.self)
    }
}
