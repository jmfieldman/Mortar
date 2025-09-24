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
}

public extension ManagedTableViewCellModel {
    var onSelect: ((ManagedTableView, IndexPath) -> Void)? { nil }
}

public protocol ManagedTableViewCell: UITableViewCell {
    associatedtype Model: ManagedTableViewCellModel
}

extension ManagedTableViewCell {
    func update(model: Model) {
        __AssociatedMutableProperty(self, Model.self).value = model
    }

    public var model: AnyPublisher<Model, Never> {
        __AssociatedPublisher(self, Model.self)
    }
}

#endif
