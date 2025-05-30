//
//  ManagedTableViewCell.swift
//  Copyright © 2025 Jason Fieldman.
//

import CombineEx
import UIKit

public protocol ManagedTableViewCellModel {
    associatedtype Cell: ManagedTableViewCell
    var onSelect: (() -> Void)? { get }
}

public extension ManagedTableViewCellModel {
    var onSelect: (() -> Void)? { nil }
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

private var kAssociatedPublisherKey = 0
private var kAssociatedMutablePropertyKey = 0

func __AssociatedMutableProperty<T>(_ object: AnyObject, _ type: T.Type) -> MutableProperty<T?> {
    if let property = objc_getAssociatedObject(object, &kAssociatedMutablePropertyKey) as? MutableProperty<T?> {
        return property
    }

    let property = MutableProperty<T?>(nil)
    objc_setAssociatedObject(
        object,
        &kAssociatedMutablePropertyKey,
        property,
        objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
    )
    return property
}

func __AssociatedPublisher<T>(_ object: AnyObject, _ type: T.Type) -> AnyPublisher<T, Never> {
    if let publisher = objc_getAssociatedObject(object, &kAssociatedPublisherKey) as? AnyPublisher<T, Never> {
        return publisher
    }

    let publisher = __AssociatedMutableProperty(object, type).compactMap(\.self).eraseToAnyPublisher()
    objc_setAssociatedObject(
        object,
        &kAssociatedPublisherKey,
        publisher,
        objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
    )
    return publisher
}
