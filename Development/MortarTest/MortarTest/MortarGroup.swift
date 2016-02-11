//
//  MortarGroup.swift
//  MortarTest
//
//  Created by Jason Fieldman on 1/30/16.
//  Copyright © 2016 Jason Fieldman. All rights reserved.
//

import Foundation
import UIKit

public typealias MortarGroup = [MortarConstraint]

public extension Array where Element: MortarConstraint {

    public func activate() -> MortarGroup {
        NSLayoutConstraint.activateConstraints(self.layoutConstraints)
        return self
    }
    
    public func deactivate() -> MortarGroup {
        NSLayoutConstraint.deactivateConstraints(self.layoutConstraints)
        return self
    }
    
    public var layoutConstraints: [NSLayoutConstraint] {
        var response: [NSLayoutConstraint] = []
        self.forEach {
            response += $0.layoutConstraints
        }
        return response
    }
    
}