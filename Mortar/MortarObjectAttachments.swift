//
//  MortarObjectAttachments.swift
//  Copyright © 2025 Jason Fieldman.
//

import Foundation

private var kPermanentObjDictAssociationKey = 0

/// Returns a dictionary used for storing permanently-associated values, creating one if it doesn't exist.
///
/// - Parameter object: The object to associate the mutable set with.
/// - Returns: An `NSMutableSet` instance associated with the given object.
func __AnyObjectPermanentObjDictStorage(_ object: AnyObject) -> NSMutableDictionary {
    if let dict = objc_getAssociatedObject(object, &kPermanentObjDictAssociationKey) as? NSMutableDictionary {
        return dict
    }

    let dict = NSMutableDictionary()
    objc_setAssociatedObject(object, &kPermanentObjDictAssociationKey, dict, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    return dict
}

extension NSObject {
    func permanentlyAssociate<T>(_ t: T) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }

        let storage = __AnyObjectPermanentObjDictStorage(self)
        let key = ObjectIdentifier(T.self)

        var array = storage[key] as? NSMutableArray
        if array == nil {
            array = NSMutableArray(capacity: 32)
            storage[key] = array
        }

        array?.add(t)
    }
}
