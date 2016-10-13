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
public protocol MortarNSObjectCreatable {
    init()
}

/// An NSObject, and those inheriting from it, can be instantiated
/// without parameters.
extension NSObject: MortarNSObjectCreatable { }


/// Implement the create() static function for NSObjectCreatable
public extension MortarNSObjectCreatable {
    
    
    /// Instantiates an instance of the receiving NSObject and
    /// calls the creation function on it.
    ///
    /// - parameter creatorFunc: A function that takes the newly
    ///                          created instance and performs any
    ///                          desired configuration on it.
    ///
    /// - returns: The newly created instance.
    public static func m_create(creatorFunc: (Self) -> Void) -> Self {
        let retval = self.init()
        creatorFunc(retval)
        return retval
    }
}
