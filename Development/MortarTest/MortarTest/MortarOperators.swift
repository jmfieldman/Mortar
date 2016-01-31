//
//  Mortar+Operators.swift
//  MortarTest
//
//  Created by Jason Fieldman on 1/30/16.
//  Copyright © 2016 Jason Fieldman. All rights reserved.
//

import Foundation
import UIKit


/*

view1.m_TLcorner |=| (self.view.m_width * 0.5, self.view.m_height * 0.5 + 10) ! .Low
view1.m_size     |=| (40, 50)
view1.m_size     |=| (view1.m_width, view2.m_height)
view2.m_center   |=| self.view
view1.m_top      |=| [self.view, view2, view3]
view1            |=| [self.view.m_bottom, self.view.m_sides]
view1.m_height   |=| 40 ! .Low
*/

infix operator |=| {}
infix operator |>| {}
infix operator |<| {}


/**
 Handle the basic case of joining two Mortar Attributes into a constraint
 e.g: 
 
 view1.m_top |=| view2.m_bottom
 
 Will set the top of view1 to the bottom of view2
*/
public func |=|(lhs: MortarAttribute, rhs: MortarAttribute) -> MortarConstraint {
    return MortarConstraint(targetMortar: lhs, sourceMortar: rhs, relation: .Equal)
}

public func |>|(lhs: MortarAttribute, rhs: MortarAttribute) -> MortarConstraint {
    return MortarConstraint(targetMortar: lhs, sourceMortar: rhs, relation: .GreaterThanOrEqual)
}

public func |<|(lhs: MortarAttribute, rhs: MortarAttribute) -> MortarConstraint {
    return MortarConstraint(targetMortar: lhs, sourceMortar: rhs, relation: .LessThanOrEqual)
}


/**
 Handle the mortar operators that combine two UIView's without specifying attributes.
 This operates implicitly on each view's edge attribute
 e.g:
 
 view1 |=| view2
 
 is equivalent to:
 
 view1.m_edges |=| view2.m_edges
 
 */
public func |=|(lhs: UIView, rhs: UIView) -> MortarConstraint {
    return MortarConstraint(targetView: lhs, sourceView: rhs, relation: .Equal)
}

public func |>|(lhs: UIView, rhs: UIView) -> MortarConstraint {
    return MortarConstraint(targetView: lhs, sourceView: rhs, relation: .GreaterThanOrEqual)
}

public func |<|(lhs: UIView, rhs: UIView) -> MortarConstraint {
    return MortarConstraint(targetView: lhs, sourceView: rhs, relation: .LessThanOrEqual)
}


/**
 Handle the mortar operators that combine a UIView without specifying its attributes.
 This operates implicitly on the view's attribute that matches the attribute on the other side.
 e.g:
 
 view1.m_top |=| view2
  - or -
 view1       |=| view2.m_top
 
 is equivalent to:
 
 view1.m_top |=| view2.m_top
 
 */
public func |=|(lhs: MortarAttribute, rhs: UIView) -> MortarConstraint {
    return MortarConstraint(targetMortar: lhs, sourceView: rhs, relation: .Equal)
}

public func |>|(lhs: MortarAttribute, rhs: UIView) -> MortarConstraint {
    return MortarConstraint(targetMortar: lhs, sourceView: rhs, relation: .GreaterThanOrEqual)
}

public func |<|(lhs: MortarAttribute, rhs: UIView) -> MortarConstraint {
    return MortarConstraint(targetMortar: lhs, sourceView: rhs, relation: .LessThanOrEqual)
}

public func |=|(lhs: UIView, rhs: MortarAttribute) -> MortarConstraint {
    return MortarConstraint(targetView: lhs, sourceMortar: rhs, relation: .Equal)
}

public func |>|(lhs: UIView, rhs: MortarAttribute) -> MortarConstraint {
    return MortarConstraint(targetView: lhs, sourceMortar: rhs, relation: .GreaterThanOrEqual)
}

public func |<|(lhs: UIView, rhs: MortarAttribute) -> MortarConstraint {
    return MortarConstraint(targetView: lhs, sourceMortar: rhs, relation: .LessThanOrEqual)
}


/**
 Handle multiplier/constant modifiers to MortarAttributes using basic arithmetic operators
 
 e.g. these are valid:
 
 view1.m_top    + 40
 view1.m_bottom - 40
 view1.m_width  * 2.0
 view1.m_height / 3.0
 view1.m_size   * 2.0 + 10    <-- chains multiplier/constant together
 
*/
public func +(lhs: MortarAttribute, rhs: Mortar_CGFloatable) -> MortarAttribute {
    lhs.constant = Array<CGFloat>(count: kMortarConstArrayLen, repeatedValue: rhs.m_cgfloatValue())
    return lhs
}

public func -(lhs: MortarAttribute, rhs: Mortar_CGFloatable) -> MortarAttribute {
    lhs.constant = Array<CGFloat>(count: kMortarConstArrayLen, repeatedValue: -rhs.m_cgfloatValue())
    return lhs
}

public func *(lhs: MortarAttribute, rhs: Mortar_CGFloatable) -> MortarAttribute {
    lhs.multiplier = Array<CGFloat>(count: kMortarConstArrayLen, repeatedValue: rhs.m_cgfloatValue())
    return lhs
}

public func /(lhs: MortarAttribute, rhs: Mortar_CGFloatable) -> MortarAttribute {
    lhs.multiplier = Array<CGFloat>(count: kMortarConstArrayLen, repeatedValue: 1.0 / rhs.m_cgfloatValue())
    return lhs
}


/**
 Allow constraints to apply directly to numbers.  This creates implicit
 relationships to the target's superview

 e.g.

 view1.m_top |=| 50  

-- is equivalent to --

 view1.m_top |=| view1.superview.m_top + 50
 
 Note that the target must be an explicit attribute (cannot infer attribute explicitly)
*/
public func |=|(lhs: MortarAttribute, rhs: Mortar_CGFloatable) -> MortarConstraint {
    return MortarConstraint(targetMortar: lhs, sourceMortar: MortarAttribute(constant: rhs.m_cgfloatValue()), relation: .Equal)
}

public func |>|(lhs: MortarAttribute, rhs: Mortar_CGFloatable) -> MortarConstraint {
    return MortarConstraint(targetMortar: lhs, sourceMortar: MortarAttribute(constant: rhs.m_cgfloatValue()), relation: .GreaterThanOrEqual)
}

public func |<|(lhs: MortarAttribute, rhs: Mortar_CGFloatable) -> MortarConstraint {
    return MortarConstraint(targetMortar: lhs, sourceMortar: MortarAttribute(constant: rhs.m_cgfloatValue()), relation: .LessThanOrEqual)
}
