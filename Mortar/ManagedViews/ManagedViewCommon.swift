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

private var kAssociatedPropertyKey = 0
private var kAssociatedMutablePropertyKey = 0

func __AssociatedMutableProperty<T>(_ object: AnyObject, _ type: T.Type, _ initialValue: T, _ created: inout Bool) -> MutableProperty<T> {
    if let property = objc_getAssociatedObject(object, &kAssociatedMutablePropertyKey) as? MutableProperty<T> {
        return property
    }

    created = true
    let property = MutableProperty<T>(initialValue)
    objc_setAssociatedObject(object, &kAssociatedMutablePropertyKey, property, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    objc_setAssociatedObject(object, &kAssociatedPropertyKey, Property(property), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    return property
}

func __AssociatedProperty<T>(_ object: AnyObject, _ type: T.Type) -> Property<T> {
    guard let property = objc_getAssociatedObject(object, &kAssociatedPropertyKey) as? Property<T> else {
        fatalError("Cannot access __AssociatedProperty before __AssociatedMutableProperty. Do not access the model in the initializer")
    }
    return property
}
