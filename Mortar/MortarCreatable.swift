//
//  NSObject+Mortar.swift
//  Mortar
//
//  Created by Jason Fieldman on 10/13/16.
//  Copyright © 2016 Jason Fieldman. All rights reserved.
//

import Foundation

/// This protocol declares that the object can be instantiated with a
/// parameter-less initializer
public protocol MortarCreatable {
    init()
}

/// Implement the create() static function for NSObjectCreatable
public extension MortarCreatable {
    
    /// Instantiates an instance of the receiving NSObject and
    /// calls the creation function on it.
    ///
    /// - parameter creatorFunc: A function that takes the newly
    ///                          created instance and performs any
    ///                          desired configuration on it.
    ///
    /// - returns: The newly created instance.
    static func create(creatorFunc: (Self) -> Void) -> Self {
        let retval = self.init()
        creatorFunc(retval)
        return retval
    }

    /// Executes the block on self, and returns self. Useful as
    /// a followup to object instantiation that requires parameters
    /// and cannot use `create`.
    ///
    /// - parameter alsoFunc: A function that takes the receiver
    ///                       and performs any desired configuration.
    ///
    /// - returns: The receiver.
    func also(_ alsoFunc: (Self) -> Void) -> Self {
        alsoFunc(self)
        return self
    }
}

/// This protocol declares that the object can be instantiated with a
/// parameter-less initializer
public protocol MortarFastCreatable {
    init()
}

public extension MortarFastCreatable {
    init(_ block: (Self) -> Void) {
        self.init()
        block(self)
    }
}
