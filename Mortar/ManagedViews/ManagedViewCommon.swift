//
//  ManagedViewCommon.swift
//  Copyright © 2025 Jason Fieldman.
//

import CombineEx
import Foundation

#if os(iOS) || os(tvOS)
import UIKit
#else
import AppKit
#endif

// MARK: ArbitrarilyIdentifiable

/// Managed models can conform to `ArbitrarilyIdentifiable` to provide arbitrary
/// `id` values. This is useful for models of non-collection-esque data such as
/// settings screens.
public protocol ArbitrarilyIdentifiable: Identifiable {}

public extension ArbitrarilyIdentifiable {
    var id: String { UUID().uuidString }
}

// MARK: Associated Properties

private var kAssociatedPublisherKey = 0
private var kAssociatedMutablePropertyKey = 0

func __AssociatedMutableProperty<T>(_ object: AnyObject, _ type: T.Type) -> MutableProperty<T?> {
    if let property = objc_getAssociatedObject(object, &kAssociatedMutablePropertyKey) as? MutableProperty<T?> {
        return property
    }

    let property = MutableProperty<T?>(nil)
    objc_setAssociatedObject(object, &kAssociatedMutablePropertyKey, property, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    return property
}

func __AssociatedPublisher<T>(_ object: AnyObject, _ type: T.Type) -> AnyPublisher<T, Never> {
    if let publisher = objc_getAssociatedObject(object, &kAssociatedPublisherKey) as? AnyPublisher<T, Never> {
        return publisher
    }

    let publisher = __AssociatedMutableProperty(object, type).compactMap(\.self).eraseToAnyPublisher()
    objc_setAssociatedObject(object, &kAssociatedPublisherKey, publisher, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    return publisher
}
