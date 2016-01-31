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
public func |=|(lhs: MortarAttributable, rhs: MortarAttributable) -> MortarConstraint {
    return MortarConstraint(target: lhs, source: rhs, relation: .Equal)
}

public func |>|(lhs: MortarAttributable, rhs: MortarAttributable) -> MortarConstraint {
    return MortarConstraint(target: lhs, source: rhs, relation: .GreaterThanOrEqual)
}

public func |<|(lhs: MortarAttributable, rhs: MortarAttributable) -> MortarConstraint {
    return MortarConstraint(target: lhs, source: rhs, relation: .LessThanOrEqual)
}



public func |=|(lhs: MortarAttribute, rhs: MortarTwople) -> MortarConstraint {
    return MortarConstraint(target: lhs, source: MortarConvertTwople(rhs), relation: .Equal)
}

public func |>|(lhs: MortarAttribute, rhs: MortarTwople) -> MortarConstraint {
    return MortarConstraint(target: lhs, source: MortarConvertTwople(rhs), relation: .GreaterThanOrEqual)
}

public func |<|(lhs: MortarAttribute, rhs: MortarTwople) -> MortarConstraint {
    return MortarConstraint(target: lhs, source: MortarConvertTwople(rhs), relation: .LessThanOrEqual)
}


public func |=|(lhs: MortarAttribute, rhs: MortarFourple) -> MortarConstraint {
    return MortarConstraint(target: lhs, source: MortarConvertFourple(rhs), relation: .Equal)
}

public func |>|(lhs: MortarAttribute, rhs: MortarFourple) -> MortarConstraint {
    return MortarConstraint(target: lhs, source: MortarConvertFourple(rhs), relation: .GreaterThanOrEqual)
}

public func |<|(lhs: MortarAttribute, rhs: MortarFourple) -> MortarConstraint {
    return MortarConstraint(target: lhs, source: MortarConvertFourple(rhs), relation: .LessThanOrEqual)
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
public func +(lhs: MortarAttribute, rhs: MortarCGFloatable) -> MortarAttribute {
    lhs.constant = rhs.m_cgfloatValue()
    return lhs
}

public func -(lhs: MortarAttribute, rhs: MortarCGFloatable) -> MortarAttribute {
    lhs.constant = -rhs.m_cgfloatValue()
    return lhs
}

public func *(lhs: MortarAttribute, rhs: MortarCGFloatable) -> MortarAttribute {
    lhs.multiplier = rhs.m_cgfloatValue()
    return lhs
}

public func /(lhs: MortarAttribute, rhs: MortarCGFloatable) -> MortarAttribute {
    lhs.multiplier = 1.0 / rhs.m_cgfloatValue()
    return lhs
}





