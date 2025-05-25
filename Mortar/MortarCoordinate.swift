//
//  MortarCoordinate.swift
//  Copyright © 2016 Jason Fieldman.
//

import CombineEx

public struct MortarCoordinate {
    let item: AnyObject?
    let attribute: MortarLayoutAttribute?
    let multiplier: UIProperty<CGFloat>?
    let constant: UIProperty<[CGFloat]>?
    let priority: MortarLayoutPriority?
}
