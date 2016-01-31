//
//  MortarAttribute.swift
//  MortarTest
//
//  Created by Jason Fieldman on 1/30/16.
//  Copyright © 2016 Jason Fieldman. All rights reserved.
//

import Foundation
import UIKit

public class MortarAttribute {
    
    /** Affected view for this mortar element */
    internal var view: UIView
    
    /** attribute is assigned for Mortar elements of type .ViewAttribute */
    internal var attribute: MortarLayoutAttribute
    
    /** The multiplier to apply to this attribute */
    internal var multiplier: CGFloat = 1.0
    
    /** The offset constant to apply to this attribute */
    internal var constant: CGFloat = 0.0
    
    /** What is the marked priority of this attribute as a source */
    internal var priority: UILayoutPriority = (UILayoutPriorityDefaultHigh + UILayoutPriorityDefaultLow) / 2.0
    
    /**
     Initialize a Mortar object to represent the layout attribute of a particular view.
     
     - parameter view:      The UIView to represent
     - parameter attribute: The layout attribute
     
     - returns: A Mortar object representing the layout property of this view
     */
    internal init(view: UIView, attribute: MortarLayoutAttribute) {
        self.view      = view
        self.attribute = attribute        
    }
    
}
