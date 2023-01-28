//
//  NSObject+Mortar.swift
//  Mortar
//
//  Created by Jason Fieldman on 10/13/16.
//  Copyright © 2016 Jason Fieldman. All rights reserved.
//

import Foundation

/// Provides default MortarCreatable support for all NSObject-based
/// classes.  This is included in the default Mortar spec for backwards
/// compatibility but may break codebases that contain class definitions
/// that do not always wish to expose init().  For those codebases
/// they should use:
///
/// pod 'Mortar/Core_NoCreatable'
///
/// and can put this code to allow `create` to be used on classes:
///
/// extension (your-class-name): MortarCreatable { }
extension NSObject: MortarCreatable { }
