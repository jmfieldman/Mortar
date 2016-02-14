//
//  Mortar
//
//  Copyright (c) 2016-Present Jason Fieldman - https://github.com/jmfieldman/Mortar
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#if os(iOS) || os(tvOS)
import UIKit
#else
import AppKit
#endif



/**
 The |+| operator is used as an addSubview substitude.  Allows adding arrays, which can be
 formatted in text into a view hierarchy.

    v1 |+| [
        v2,
        v3 |+| [
            v4
        ]
    ]
*/
infix operator |+| { precedence 95 }
infix operator |^| { precedence 95 }

public func |+|(lhs: MortarView, rhs: MortarView) -> MortarView {
    lhs.addSubview(rhs)
    return lhs
}

public func |+|(lhs: MortarView, rhs: [MortarView]) -> MortarView {
    rhs.forEach { lhs.addSubview($0) }
    return lhs
}

public func |^|(lhs: MortarView, rhs: MortarView) -> MortarView {
    lhs.addSubview(rhs)
    return lhs
}

public func |^|(lhs: MortarView, rhs: [MortarView]) -> MortarView {
    for i in (0..<rhs.count).reverse() {
        lhs.addSubview(rhs[i])
    }    
    return lhs
}



/* The basic mortar operators to create equal, less-than-or-equal, and greater-than-or-equal */
infix operator |=| { precedence 95 }
infix operator |>| { precedence 95 }
infix operator |<| { precedence 95 }


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



/**
 Handle the basic case of joining a Mortar Attribute with a tuple
 e.g:

 view1.m_size |=| (50, 50)

*/
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



public func |=|(lhs: MortarAttribute, rhs: MortarTuple) -> MortarConstraint {
    return MortarConstraint(target: lhs, source: rhs, relation: .Equal)
}

public func |>|(lhs: MortarAttribute, rhs: MortarTuple) -> MortarConstraint {
    return MortarConstraint(target: lhs, source: rhs, relation: .GreaterThanOrEqual)
}

public func |<|(lhs: MortarAttribute, rhs: MortarTuple) -> MortarConstraint {
    return MortarConstraint(target: lhs, source: rhs, relation: .LessThanOrEqual)
}


/**
 Handle constraints involving arrays
 e.g:

 view1 |=| [view2.m_bottom, view3.m_left]

 [view1.m_top, view1.m_left] |=| [view2.m_bottom, view3.m_left]

*/
public func |=|(lhs: [MortarAttributable], rhs: [MortarAttributable]) -> MortarConstraint {
    return MortarConstraint(targetArray: lhs.map { $0.m_intoAttribute() },
                            sourceArray: rhs.map { $0.m_intoAttribute() },
                              crosslink: false,
                               relation: .Equal)
}

public func |>|(lhs: [MortarAttributable], rhs: [MortarAttributable]) -> MortarConstraint {
    return MortarConstraint(targetArray: lhs.map { $0.m_intoAttribute() },
                            sourceArray: rhs.map { $0.m_intoAttribute() },
                              crosslink: false,
                               relation: .GreaterThanOrEqual)
}

public func |<|(lhs: [MortarAttributable], rhs: [MortarAttributable]) -> MortarConstraint {
    return MortarConstraint(targetArray: lhs.map { $0.m_intoAttribute() },
                            sourceArray: rhs.map { $0.m_intoAttribute() },
                              crosslink: false,
                               relation: .LessThanOrEqual)
}


public func |=|(lhs: MortarAttributable, rhs: [MortarAttributable]) -> MortarConstraint {
    return MortarConstraint(targetArray: [lhs.m_intoAttribute()],
                            sourceArray: rhs.map { $0.m_intoAttribute() },
                              crosslink: true,
                               relation: .Equal)
}

public func |>|(lhs: MortarAttributable, rhs: [MortarAttributable]) -> MortarConstraint {
    return MortarConstraint(targetArray: [lhs.m_intoAttribute()],
                            sourceArray: rhs.map { $0.m_intoAttribute() },
                              crosslink: true,
                               relation: .GreaterThanOrEqual)
}

public func |<|(lhs: MortarAttributable, rhs: [MortarAttributable]) -> MortarConstraint {
    return MortarConstraint(targetArray: [lhs.m_intoAttribute()],
                            sourceArray: rhs.map { $0.m_intoAttribute() },
                              crosslink: true,
                               relation: .LessThanOrEqual)
}

public func |=|(lhs: [MortarAttributable], rhs: MortarAttributable) -> MortarConstraint {
    return MortarConstraint(targetArray: lhs.map { $0.m_intoAttribute() },
                            sourceArray: [rhs.m_intoAttribute()],
                              crosslink: true,
                               relation: .Equal)
}

public func |>|(lhs: [MortarAttributable], rhs: MortarAttributable) -> MortarConstraint {
    return MortarConstraint(targetArray: lhs.map { $0.m_intoAttribute() },
                            sourceArray: [rhs.m_intoAttribute()],
                              crosslink: true,
                               relation: .GreaterThanOrEqual)
}

public func |<|(lhs: [MortarAttributable], rhs: MortarAttributable) -> MortarConstraint {
    return MortarConstraint(targetArray: lhs.map { $0.m_intoAttribute() },
                            sourceArray: [rhs.m_intoAttribute()],
                              crosslink: true,
                               relation: .LessThanOrEqual)
}

public func |=|(lhs: [MortarAttribute], rhs: MortarAttributable) -> MortarConstraint {
    return MortarConstraint(targetArray: lhs,
                            sourceArray: [rhs.m_intoAttribute()],
                              crosslink: true,
                               relation: .Equal)
}

public func |>|(lhs: [MortarAttribute], rhs: MortarAttributable) -> MortarConstraint {
    return MortarConstraint(targetArray: lhs,
                            sourceArray: [rhs.m_intoAttribute()],
                              crosslink: true,
                               relation: .GreaterThanOrEqual)
}

public func |<|(lhs: [MortarAttribute], rhs: MortarAttributable) -> MortarConstraint {
    return MortarConstraint(targetArray: lhs,
                            sourceArray: [rhs.m_intoAttribute()],
                              crosslink: true,
                               relation: .LessThanOrEqual)
}


/**
 Handle the concept of allowing several attributes to join with a tuple
 e.g:

 [view1, view2, view3, view4].m_size |=| (50, 50)

*/
public func |=|(lhs: [MortarAttributable], rhs: MortarTuple) -> MortarConstraint {
    return MortarConstraint(targetArray: lhs.map { $0.m_intoAttribute() },
                            sourceTuple: rhs,
                               relation: .Equal)
}

public func |>|(lhs: [MortarAttributable], rhs: MortarTuple) -> MortarConstraint {
    return MortarConstraint(targetArray: lhs.map { $0.m_intoAttribute() },
                            sourceTuple: rhs,
                               relation: .GreaterThanOrEqual)
}

public func |<|(lhs: [MortarAttributable], rhs: MortarTuple) -> MortarConstraint {
    return MortarConstraint(targetArray: lhs.map { $0.m_intoAttribute() },
                            sourceTuple: rhs,
                               relation: .LessThanOrEqual)
}


public func |=|(lhs: [MortarAttributable], rhs: MortarTwople) -> MortarConstraint {
    return lhs |=| MortarConvertTwople(rhs)
}

public func |>|(lhs: [MortarAttributable], rhs: MortarTwople) -> MortarConstraint {
    return lhs |>| MortarConvertTwople(rhs)
}

public func |<|(lhs: [MortarAttributable], rhs: MortarTwople) -> MortarConstraint {
    return lhs |<| MortarConvertTwople(rhs)
}

public func |=|(lhs: [MortarAttributable], rhs: MortarFourple) -> MortarConstraint {
    return lhs |=| MortarConvertFourple(rhs)
}

public func |>|(lhs: [MortarAttributable], rhs: MortarFourple) -> MortarConstraint {
    return lhs |>| MortarConvertFourple(rhs)
}

public func |<|(lhs: [MortarAttributable], rhs: MortarFourple) -> MortarConstraint {
    return lhs |<| MortarConvertFourple(rhs)
}

/* Catch-all array operators */
public func |=|(lhs: [Any], rhs: [Any]) -> MortarConstraint {
    return MortarConstraint(targetAnyArray: lhs, sourceAnyArray: rhs, crosslink: false, relation: .Equal)
}

public func |>|(lhs: [Any], rhs: [Any]) -> MortarConstraint {
    return MortarConstraint(targetAnyArray: lhs, sourceAnyArray: rhs, crosslink: false, relation: .GreaterThanOrEqual)
}

public func |<|(lhs: [Any], rhs: [Any]) -> MortarConstraint {
    return MortarConstraint(targetAnyArray: lhs, sourceAnyArray: rhs, crosslink: false, relation: .LessThanOrEqual)
}


/**
 Handle multiplier/constant modifiers to MortarAttributes using basic arithmetic operators
 
 e.g. these are valid:
 
 view1.m_top    + 40
 view1.m_bottom - 40
 view1.m_width  * 2.0
 view1.m_height / 3.0
 view1.m_size   * 2.0 + 10  <-- chains multiplier/constant together
 
*/
public func +(lhs: MortarAttribute, rhs: MortarCGFloatable) -> MortarAttribute {
    for i in 0 ..< kMortarConstArrayLen {
        lhs.constant[i] += rhs.m_cgfloatValue()
    }
    return lhs
}

public func -(lhs: MortarAttribute, rhs: MortarCGFloatable) -> MortarAttribute {
    for i in 0 ..< kMortarConstArrayLen {
        lhs.constant[i] -= rhs.m_cgfloatValue()
    }
    return lhs
}

public func *(lhs: MortarAttribute, rhs: MortarCGFloatable) -> MortarAttribute {
    for i in 0 ..< kMortarConstArrayLen {
        lhs.multiplier[i] *= rhs.m_cgfloatValue()
    }
    return lhs
}

public func /(lhs: MortarAttribute, rhs: MortarCGFloatable) -> MortarAttribute {
    for i in 0 ..< kMortarConstArrayLen {
        lhs.multiplier[i] /= rhs.m_cgfloatValue()
    }
    return lhs
}

/* This is only using for chaining constants with priorities attached */

public func +(lhs: MortarAttribute, rhs: MortarAttribute) -> MortarAttribute {
    if (rhs.view != nil || rhs.attribute != nil) {
        NSException(name: "Right side of arithmetic must be constant",
                  reason: "When performing mortar arithmetic, the right side must be a constant (cannot have view or attribute)",
                userInfo: nil).raise()
    }

    for i in 0 ..< kMortarConstArrayLen {
        lhs.constant[i] += rhs.constant[i]
    }
    
    lhs.priority =  rhs.priority
    return lhs
}

public func -(lhs: MortarAttribute, rhs: MortarAttribute) -> MortarAttribute {
    if (rhs.view != nil || rhs.attribute != nil) {
        NSException(name: "Right side of arithmetic must be constant",
                  reason: "When performing mortar arithmetic, the right side must be a constant (cannot have view or attribute)",
                userInfo: nil).raise()
    }
    
    for i in 0 ..< kMortarConstArrayLen {
        lhs.constant[i] -= rhs.constant[i]
    }
    
    lhs.priority =  rhs.priority
    return lhs
}

public func *(lhs: MortarAttribute, rhs: MortarAttribute) -> MortarAttribute {
    if (rhs.view != nil || rhs.attribute != nil) {
        NSException(name: "Right side of arithmetic must be constant",
                  reason: "When performing mortar arithmetic, the right side must be a constant (cannot have view or attribute)",
                userInfo: nil).raise()
    }
    
    for i in 0 ..< kMortarConstArrayLen {
        lhs.constant[i] *= rhs.constant[i]
    }
    
    lhs.priority    = rhs.priority
    return lhs
}

public func /(lhs: MortarAttribute, rhs: MortarAttribute) -> MortarAttribute {
    if (rhs.view != nil || rhs.attribute != nil) {
        NSException(name: "Right side of arithmetic must be constant",
                  reason: "When performing mortar arithmetic, the right side must be a constant (cannot have view or attribute)",
                userInfo: nil).raise()
    }
    
    for i in 0 ..< kMortarConstArrayLen {
        lhs.constant[i] /= rhs.constant[i]
    }
    
    lhs.priority    = rhs.priority
    return lhs
}


public func *(lhs: MortarCGFloatable, rhs: CGFloat) -> CGFloat {
    return lhs.m_cgfloatValue() * rhs
}


/**
 Attributable (arithmetic) (const-tuple)
*/

public func +(lhs: MortarAttribute, rhs: MortarConstTwo) -> MortarAttribute {
    guard let components = lhs.attribute?.componentAttributes() else {
        NSException(name: "Attribute has no components for tuple arithmetic",
                  reason: "Attribute has no components for tuple arithmetic",
                userInfo: nil).raise()
        return lhs
    }
    
    if (components.count != 2) {
        NSException(name: "Attribute has wrong component count",
                  reason: "Attribute has \(components.count) components; requires 2",
                userInfo: nil).raise()
        return lhs
    }
    
    lhs.constant[0] += rhs.0.m_cgfloatValue()
    lhs.constant[1] += rhs.1.m_cgfloatValue()
    return lhs
}

public func +(lhs: MortarAttribute, rhs: MortarConstFour) -> MortarAttribute {
    guard let components = lhs.attribute?.componentAttributes() else {
        NSException(name: "Attribute has no components for tuple arithmetic",
                  reason: "Attribute has no components for tuple arithmetic",
                userInfo: nil).raise()
        return lhs
    }
    
    if (components.count != 4) {
        NSException(name: "Attribute has wrong component count",
                  reason: "Attribute has \(components.count) components; requires 4",
                userInfo: nil).raise()
        return lhs
    }
    
    lhs.constant[0] += rhs.0.m_cgfloatValue()
    lhs.constant[1] += rhs.1.m_cgfloatValue()
    lhs.constant[2] += rhs.2.m_cgfloatValue()
    lhs.constant[3] += rhs.3.m_cgfloatValue()
    return lhs
}

public func -(lhs: MortarAttribute, rhs: MortarConstTwo) -> MortarAttribute {
    guard let components = lhs.attribute?.componentAttributes() else {
        NSException(name: "Attribute has no components for tuple arithmetic",
                  reason: "Attribute has no components for tuple arithmetic",
                userInfo: nil).raise()
        return lhs
    }
    
    if (components.count != 2) {
        NSException(name: "Attribute has wrong component count",
                  reason: "Attribute has \(components.count) components; requires 2",
                userInfo: nil).raise()
        return lhs
    }
    
    lhs.constant[0] -= rhs.0.m_cgfloatValue()
    lhs.constant[1] -= rhs.1.m_cgfloatValue()
    return lhs
}

public func -(lhs: MortarAttribute, rhs: MortarConstFour) -> MortarAttribute {
    guard let components = lhs.attribute?.componentAttributes() else {
        NSException(name: "Attribute has no components for tuple arithmetic",
                  reason: "Attribute has no components for tuple arithmetic",
                userInfo: nil).raise()
        return lhs
    }
    
    if (components.count != 4) {
        NSException(name: "Attribute has wrong component count",
                  reason: "Attribute has \(components.count) components; requires 4",
                userInfo: nil).raise()
        return lhs
    }
    
    lhs.constant[0] -= rhs.0.m_cgfloatValue()
    lhs.constant[1] -= rhs.1.m_cgfloatValue()
    lhs.constant[2] -= rhs.2.m_cgfloatValue()
    lhs.constant[3] -= rhs.3.m_cgfloatValue()
    return lhs
}

public func *(lhs: MortarAttribute, rhs: MortarConstTwo) -> MortarAttribute {
    guard let components = lhs.attribute?.componentAttributes() else {
        NSException(name: "Attribute has no components for tuple arithmetic",
                  reason: "Attribute has no components for tuple arithmetic",
                userInfo: nil).raise()
        return lhs
    }
    
    if (components.count != 2) {
        NSException(name: "Attribute has wrong component count",
                  reason: "Attribute has \(components.count) components; requires 2",
                userInfo: nil).raise()
        return lhs
    }
    
    lhs.multiplier[0] *= rhs.0.m_cgfloatValue()
    lhs.multiplier[1] *= rhs.1.m_cgfloatValue()
    return lhs
}

public func *(lhs: MortarAttribute, rhs: MortarConstFour) -> MortarAttribute {
    guard let components = lhs.attribute?.componentAttributes() else {
        NSException(name: "Attribute has no components for tuple arithmetic",
                  reason: "Attribute has no components for tuple arithmetic",
                userInfo: nil).raise()
        return lhs
    }
    
    if (components.count != 4) {
        NSException(name: "Attribute has wrong component count",
                  reason: "Attribute has \(components.count) components; requires 4",
                userInfo: nil).raise()
        return lhs
    }
    
    lhs.multiplier[0] *= rhs.0.m_cgfloatValue()
    lhs.multiplier[1] *= rhs.1.m_cgfloatValue()
    lhs.multiplier[2] *= rhs.2.m_cgfloatValue()
    lhs.multiplier[3] *= rhs.3.m_cgfloatValue()
    return lhs
}

public func /(lhs: MortarAttribute, rhs: MortarConstTwo) -> MortarAttribute {
    guard let components = lhs.attribute?.componentAttributes() else {
        NSException(name: "Attribute has no components for tuple arithmetic",
                  reason: "Attribute has no components for tuple arithmetic",
                userInfo: nil).raise()
        return lhs
    }
    
    if (components.count != 2) {
        NSException(name: "Attribute has wrong component count",
                  reason: "Attribute has \(components.count) components; requires 2",
                userInfo: nil).raise()
        return lhs
    }
    
    lhs.multiplier[0] /= rhs.0.m_cgfloatValue()
    lhs.multiplier[1] /= rhs.1.m_cgfloatValue()
    return lhs
}

public func /(lhs: MortarAttribute, rhs: MortarConstFour) -> MortarAttribute {
    guard let components = lhs.attribute?.componentAttributes() else {
        NSException(name: "Attribute has no components for tuple arithmetic",
                  reason: "Attribute has no components for tuple arithmetic",
                userInfo: nil).raise()
        return lhs
    }
    
    if (components.count != 4) {
        NSException(name: "Attribute has wrong component count",
                  reason: "Attribute has \(components.count) components; requires 4",
                userInfo: nil).raise()
        return lhs
    }
    
    lhs.multiplier[0] /= rhs.0.m_cgfloatValue()
    lhs.multiplier[1] /= rhs.1.m_cgfloatValue()
    lhs.multiplier[2] /= rhs.2.m_cgfloatValue()
    lhs.multiplier[3] /= rhs.3.m_cgfloatValue()
    return lhs
}

infix operator ~ { precedence 140 }

public func ~(lhs: MortarAttribute, rhs: MortarConstTwo) -> MortarAttribute {
    guard let components = lhs.attribute?.componentAttributes() else {
        NSException(name: "Attribute has no components for tuple arithmetic",
                  reason: "Attribute has no components for tuple arithmetic",
                userInfo: nil).raise()
        return lhs
    }
    
    if (components.count != 2) {
        NSException(name: "Attribute has wrong component count",
                  reason: "Attribute has \(components.count) components; requires 2",
                userInfo: nil).raise()
        return lhs
    }
    
    let mults = components.map { $0.insetConstantModifier() }
    
    lhs.constant[0] += rhs.0.m_cgfloatValue() * mults[0]
    lhs.constant[1] += rhs.1.m_cgfloatValue() * mults[1]
    return lhs
}

public func ~(lhs: MortarAttribute, rhs: MortarConstFour) -> MortarAttribute {
    guard let components = lhs.attribute?.componentAttributes() else {
        NSException(name: "Attribute has no components for tuple arithmetic",
                  reason: "Attribute has no components for tuple arithmetic",
                userInfo: nil).raise()
        return lhs
    }
    
    if (components.count != 4) {
        NSException(name: "Attribute has wrong component count",
                  reason: "Attribute has \(components.count) components; requires 4",
                userInfo: nil).raise()
        return lhs
    }
    
    let mults = components.map { $0.insetConstantModifier() }
    
    lhs.constant[0] += rhs.0.m_cgfloatValue() * mults[0]
    lhs.constant[1] += rhs.1.m_cgfloatValue() * mults[1]
    lhs.constant[2] += rhs.2.m_cgfloatValue() * mults[2]
    lhs.constant[3] += rhs.3.m_cgfloatValue() * mults[3]
    return lhs
}

/**
 Priority operators
*/

infix operator ! { precedence 130 }

public func !(lhs: MortarAttributable, rhs: MortarLayoutPriority) -> MortarAttribute {
    let attr = lhs.m_intoAttribute()
    attr.priority = rhs.layoutPriority()
    return attr
}

public func !(lhs: MortarAttributable, rhs: UILayoutPriority) -> MortarAttribute {
    let attr = lhs.m_intoAttribute()
    attr.priority = rhs
    return attr
}


public func !(lhs: MortarTwople, rhs: MortarLayoutPriority) -> MortarTuple {
    var tup = MortarConvertTwople(lhs)
    tup.1 = rhs.layoutPriority()
    return tup
}

public func !(lhs: MortarTwople, rhs: UILayoutPriority) -> MortarTuple {
    var tup = MortarConvertTwople(lhs)
    tup.1 = rhs
    return tup
}


public func !(lhs: MortarFourple, rhs: MortarLayoutPriority) -> MortarTuple {
    var tup = MortarConvertFourple(lhs)
    tup.1 = rhs.layoutPriority()
    return tup
}

public func !(lhs: MortarFourple, rhs: UILayoutPriority) -> MortarTuple {
    var tup = MortarConvertFourple(lhs)
    tup.1 = rhs
    return tup
}

/* Problem with this: cannot bridge array...
public func !(lhs: [MortarAttribute], rhs: MortarLayoutPriority) -> [MortarAttribute] {
    lhs.forEach { if $0.priority == nil { $0.priority = rhs.layoutPriority() } }
    return lhs
}

public func !(lhs: [MortarAttribute], rhs: UILayoutPriority) -> [MortarAttribute] {
    lhs.forEach { if $0.priority == nil { $0.priority = rhs } }
    return lhs
}
*/

/*
 Activation Operator
*/

infix operator ~~ { precedence 30 }

public func ~~(lhs: MortarConstraint, rhs: MortarActivationState) -> MortarConstraint {
    switch rhs {
    case .Activated:    lhs.activate()
    case .Deactivated:  lhs.deactivate()
    }
    return lhs
}

public func ~~(lhs: MortarGroup, rhs: MortarActivationState) -> MortarGroup {
    switch rhs {
    case .Activated:    lhs.activate()
    case .Deactivated:  lhs.deactivate()
    }
    return lhs
}


