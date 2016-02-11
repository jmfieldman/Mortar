//
//  MortarAttribute.swift
//  MortarTest
//
//  Created by Jason Fieldman on 1/30/16.
//  Copyright © 2016 Jason Fieldman. All rights reserved.
//

import Foundation
import UIKit

internal let kMortarConstArrayLen = 4


public class MortarAttribute {
    
    /** Affected view for this mortar element */
    internal var view: UIView?
    
    /** attribute is assigned for Mortar elements of type .ViewAttribute */
    internal var attribute: MortarLayoutAttribute?
    
    /** The multiplier to apply to this attribute */
    internal var multiplier: Array<CGFloat> = Array<CGFloat>(count: kMortarConstArrayLen, repeatedValue: 1.0)
    
    /** The offset constant to apply to this attribute */
    internal var constant: Array<CGFloat> = Array<CGFloat>(count: kMortarConstArrayLen, repeatedValue: 0.0)
    
    /** What is the marked priority of this attribute as a source */
    internal var priority: UILayoutPriority?

    
    /**
     Initialize a Mortar object to represent the layout attribute of a particular view.
     
     - parameter view:      The UIView to represent
     - parameter attribute: The layout attribute
     
     - returns: A Mortar object representing the layout property of this view
     */
    internal init(view: UIView?, attribute: MortarLayoutAttribute?) {
        self.view      = view
        self.attribute = attribute
    }
    
    /**
     Create a Mortar Attribute that represents an attribute-less view
     
     - parameter view: The view to create an attribute for
     
     - returns: The new Mortar Attribute
     */
    internal convenience init(view: UIView) {
        self.init(view: view, attribute: nil)
    }
    
    /**
     Create a Mortar Attribute that represents a constant metric
     
     - parameter constant: The value of the constant
     
     - returns: The new Mortar Attribute
     */
    internal convenience init(constant: MortarCGFloatable) {
        self.init(view: nil, attribute: nil)
        self.constant = Array<CGFloat>(count: kMortarConstArrayLen, repeatedValue: constant.m_cgfloatValue())
    }
    
    //internal convenience init(twople: MortarTwople) {
    //    self.init(view: nil, attribute: nil)
    //    self.constant = twople.0.m_intoAttribute()
   // }
    
}
