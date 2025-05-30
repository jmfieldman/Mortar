//
//  MortarCoordinate.swift
//  Copyright © 2016 Jason Fieldman.
//

typealias MortarConstantTuple = (CGFloat, CGFloat, CGFloat, CGFloat)

func tupleIndex(_ tuple: MortarConstantTuple, _ index: Int) -> CGFloat {
    switch index {
    case 0: tuple.0
    case 1: tuple.1
    case 2: tuple.2
    case 3: tuple.3
    default: tuple.0
    }
}

public struct MortarCoordinate {
    let item: Any?
    let attribute: MortarLayoutAttribute?
    let multiplier: CGFloat
    let constant: MortarConstantTuple
    let priority: MortarLayoutPriority
    let startActivated: Bool

    init(
        item: Any?,
        attribute: MortarLayoutAttribute?,
        multiplier: CGFloat,
        constant: MortarConstantTuple,
        priority: MortarLayoutPriority,
        startActivated: Bool = true
    ) {
        self.item = item
        self.attribute = attribute
        self.multiplier = multiplier
        self.constant = constant
        self.priority = priority
        self.startActivated = startActivated
    }
}

public protocol MortarCoordinateConvertible {
    var coordinate: MortarCoordinate { get }
}

public extension MortarCGFloatable {
    var coordinate: MortarCoordinate {
        .init(
            item: nil,
            attribute: nil,
            multiplier: 1,
            constant: (floatValue, 0, 0, 0),
            priority: .required
        )
    }
}

extension CGPoint: MortarCoordinateConvertible {
    public var coordinate: MortarCoordinate {
        .init(
            item: nil,
            attribute: nil,
            multiplier: 1,
            constant: (y, x, 0, 0),
            priority: .required
        )
    }
}

extension CGSize: MortarCoordinateConvertible {
    public var coordinate: MortarCoordinate {
        .init(
            item: nil,
            attribute: nil,
            multiplier: 1,
            constant: (width, height, 0, 0),
            priority: .required
        )
    }
}

extension MortarEdgeInsets: MortarCoordinateConvertible {
    public var coordinate: MortarCoordinate {
        .init(
            item: nil,
            attribute: nil,
            multiplier: 1,
            constant: (top, left, -bottom, -right),
            priority: .required
        )
    }
}

extension MortarView: MortarCoordinateConvertible {
    public var coordinate: MortarCoordinate {
        .init(
            item: self,
            attribute: nil,
            multiplier: 1,
            constant: (0, 0, 0, 0),
            priority: .required
        )
    }
}

extension MortarLayoutGuide: MortarCoordinateConvertible {
    public var coordinate: MortarCoordinate {
        .init(
            item: self,
            attribute: nil,
            multiplier: 1,
            constant: (0, 0, 0, 0),
            priority: .required
        )
    }
}
