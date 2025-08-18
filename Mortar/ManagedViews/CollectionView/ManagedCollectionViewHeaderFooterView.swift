//
//  ManagedCollectionViewHeaderFooterView.swift
//  Copyright © 2025 Jason Fieldman.
//

#if os(iOS) || os(tvOS)

import UIKit

public protocol ManagedCollectionReusableViewModel {
    associatedtype ReusableView: ManagedCollectionReusableView
}

public protocol ManagedCollectionReusableView: UICollectionReusableView {
    associatedtype Model: ManagedTableViewHeaderFooterViewModel
}

extension ManagedCollectionReusableView {
    func update(model: Model) {
        __AssociatedMutableProperty(self, Model.self).value = model
    }

    public var model: AnyPublisher<Model, Never> {
        __AssociatedPublisher(self, Model.self)
    }
}

#endif
