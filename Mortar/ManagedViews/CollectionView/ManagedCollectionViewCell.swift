//
//  ManagedCollectionViewCell.swift
//  Copyright © 2025 Jason Fieldman.
//

#if os(iOS) || os(tvOS)

import CombineEx
import UIKit

public protocol ManagedCollectionViewCellModel: Identifiable {
    associatedtype Cell: ManagedCollectionViewCell
    var onSelect: (() -> Void)? { get }
}

public extension ManagedCollectionViewCellModel {
    var onSelect: (() -> Void)? { nil }
}

public protocol ManagedCollectionViewCell: UICollectionViewCell {
    associatedtype Model: ManagedCollectionViewCellModel
}

extension ManagedCollectionViewCell {
    func update(model: Model) {
        __AssociatedMutableProperty(self, Model.self).value = model
    }

    public var model: AnyPublisher<Model, Never> {
        __AssociatedPublisher(self, Model.self)
    }
}

#endif
