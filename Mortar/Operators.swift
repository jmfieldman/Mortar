//
//  Operators.swift
//  Copyright © 2025 Jason Fieldman.
//

// MARK: - Constraint Constants - Single Degree

private func verifyDegrees(_ coordinate: MortarCoordinate, _ degree: Int) {
    if coordinate.attribute?.degree != degree {
        MortarError.emit("Operator used with incompatible degrees: coordinate for \(coordinate.attribute ?? .notAnAttribute) has degree \(coordinate.attribute?.degree ?? 0) but was expecting degree \(degree)")
    }
}

public func + (lhs: MortarCoordinate, rhs: MortarCGFloatable) -> MortarCoordinate {
    verifyDegrees(lhs, 1)

    return .init(
        item: lhs.item,
        attribute: lhs.attribute,
        multiplier: lhs.multiplier,
        constant: (lhs.constant.0 + rhs.floatValue, lhs.constant.1, lhs.constant.2, lhs.constant.3),
        priority: lhs.priority
    )
}

public func - (lhs: MortarCoordinate, rhs: MortarCGFloatable) -> MortarCoordinate {
    verifyDegrees(lhs, 1)

    return .init(
        item: lhs.item,
        attribute: lhs.attribute,
        multiplier: lhs.multiplier,
        constant: (lhs.constant.0 - rhs.floatValue, lhs.constant.1, lhs.constant.2, lhs.constant.3),
        priority: lhs.priority
    )
}

// MARK: - Constraint Constants - CGPoint

public func + (lhs: MortarCoordinate, rhs: CGPoint) -> MortarCoordinate {
    verifyDegrees(lhs, 2)

    return .init(
        item: lhs.item,
        attribute: lhs.attribute,
        multiplier: lhs.multiplier,
        constant: (lhs.constant.0 + rhs.y.floatValue, lhs.constant.1 + rhs.x.floatValue, lhs.constant.2, lhs.constant.3),
        priority: lhs.priority
    )
}

public func - (lhs: MortarCoordinate, rhs: CGPoint) -> MortarCoordinate {
    verifyDegrees(lhs, 2)

    return .init(
        item: lhs.item,
        attribute: lhs.attribute,
        multiplier: lhs.multiplier,
        constant: (lhs.constant.0 - rhs.y.floatValue, lhs.constant.1 - rhs.x.floatValue, lhs.constant.2, lhs.constant.3),
        priority: lhs.priority
    )
}

// MARK: - Constraint Constants - CGSize

public func + (lhs: MortarSizeCoordinate, rhs: CGSize) -> MortarSizeCoordinate {
    .init(
        item: lhs.item,
        multiplier: lhs.multiplier,
        constant: CGSize(
            width: lhs.constant.width + rhs.width,
            height: lhs.constant.height + rhs.height
        ),
        priority: lhs.priority
    )
}

public func - (lhs: MortarSizeCoordinate, rhs: CGSize) -> MortarSizeCoordinate {
    .init(
        item: lhs.item,
        multiplier: lhs.multiplier,
        constant: CGSize(
            width: lhs.constant.width - rhs.width,
            height: lhs.constant.height - rhs.height
        ),
        priority: lhs.priority
    )
}

// MARK: - Constraint Constants - Edge Insets

public func + (lhs: MortarCoordinate, rhs: MortarEdgeInsets) -> MortarCoordinate {
    verifyDegrees(lhs, 4)

    return .init(
        item: lhs.item,
        attribute: lhs.attribute,
        multiplier: lhs.multiplier,
        constant: (
            lhs.constant.0 + rhs.top,
            lhs.constant.1 + rhs.left,
            lhs.constant.2 - rhs.bottom,
            lhs.constant.3 - rhs.right
        ),
        priority: lhs.priority
    )
}

public func - (lhs: MortarCoordinate, rhs: MortarEdgeInsets) -> MortarCoordinate {
    verifyDegrees(lhs, 4)

    return .init(
        item: lhs.item,
        attribute: lhs.attribute,
        multiplier: lhs.multiplier,
        constant: (
            lhs.constant.0 - rhs.top,
            lhs.constant.1 - rhs.left,
            lhs.constant.2 + rhs.bottom,
            lhs.constant.3 + rhs.right
        ),
        priority: lhs.priority
    )
}

// MARK: - Constraint Multipliers

public func * (lhs: MortarCoordinate, rhs: MortarCGFloatable) -> MortarCoordinate {
    .init(
        item: lhs.item,
        attribute: lhs.attribute,
        multiplier: lhs.multiplier * rhs.floatValue,
        constant: lhs.constant,
        priority: lhs.priority
    )
}

public func / (lhs: MortarCoordinate, rhs: MortarCGFloatable) -> MortarCoordinate {
    .init(
        item: lhs.item,
        attribute: lhs.attribute,
        multiplier: lhs.multiplier / rhs.floatValue,
        constant: lhs.constant,
        priority: lhs.priority
    )
}

public func * (lhs: MortarSizeCoordinate, rhs: MortarCGFloatable) -> MortarSizeCoordinate {
    .init(
        item: lhs.item,
        multiplier: lhs.multiplier * rhs.floatValue,
        constant: lhs.constant,
        priority: lhs.priority
    )
}

public func / (lhs: MortarSizeCoordinate, rhs: MortarCGFloatable) -> MortarSizeCoordinate {
    .init(
        item: lhs.item,
        multiplier: lhs.multiplier / rhs.floatValue,
        constant: lhs.constant,
        priority: lhs.priority
    )
}

// MARK: - Priority Operator

public func ^ (lhs: MortarCoordinate, rhs: MortarLayoutPriority) -> MortarCoordinate {
    .init(
        item: lhs.item,
        attribute: lhs.attribute,
        multiplier: lhs.multiplier,
        constant: lhs.constant,
        priority: rhs
    )
}

public func ^ (lhs: MortarSizeCoordinate, rhs: MortarLayoutPriority) -> MortarSizeCoordinate {
    .init(
        item: lhs.item,
        multiplier: lhs.multiplier,
        constant: lhs.constant,
        priority: rhs
    )
}

public func ^ (lhs: MortarCoordinateConvertible, rhs: MortarLayoutPriority) -> MortarCoordinate {
    let coord = lhs.coordinate
    return .init(
        item: coord.item,
        attribute: coord.attribute,
        multiplier: coord.multiplier,
        constant: coord.constant,
        priority: rhs
    )
}

public func ^ (lhs: MortarSizeCoordinateConvertible, rhs: MortarLayoutPriority) -> MortarSizeCoordinate {
    let coord = lhs.coordinate
    return .init(
        item: coord.item,
        multiplier: coord.multiplier,
        constant: coord.constant,
        priority: rhs
    )
}

// MARK: - Activation Operator

public func % (lhs: MortarCoordinate, rhs: MortarActivationState) -> MortarCoordinate {
    .init(
        item: lhs.item,
        attribute: lhs.attribute,
        multiplier: lhs.multiplier,
        constant: lhs.constant,
        priority: lhs.priority,
        startActivated: rhs == .activated
    )
}

public func % (lhs: MortarSizeCoordinate, rhs: MortarActivationState) -> MortarSizeCoordinate {
    .init(
        item: lhs.item,
        multiplier: lhs.multiplier,
        constant: lhs.constant,
        priority: lhs.priority,
        startActivated: rhs == .activated
    )
}

public func % (lhs: MortarCoordinateConvertible, rhs: MortarActivationState) -> MortarCoordinate {
    let coord = lhs.coordinate
    return .init(
        item: coord.item,
        attribute: coord.attribute,
        multiplier: coord.multiplier,
        constant: coord.constant,
        priority: coord.priority,
        startActivated: rhs == .activated
    )
}

public func % (lhs: MortarSizeCoordinateConvertible, rhs: MortarActivationState) -> MortarSizeCoordinate {
    let coord = lhs.coordinate
    return .init(
        item: coord.item,
        multiplier: coord.multiplier,
        constant: coord.constant,
        priority: coord.priority,
        startActivated: rhs == .activated
    )
}

// MARK: - Relation Operators

public func == (lhs: MortarCoordinate, rhs: MortarCoordinate) -> MortarConstraintGroup {
    .init(
        target: lhs,
        source: rhs,
        relation: .equal
    )
}

public func >= (lhs: MortarCoordinate, rhs: MortarCoordinate) -> MortarConstraintGroup {
    .init(
        target: lhs,
        source: rhs,
        relation: .greaterThanOrEqual
    )
}

public func <= (lhs: MortarCoordinate, rhs: MortarCoordinate) -> MortarConstraintGroup {
    .init(
        target: lhs,
        source: rhs,
        relation: .lessThanOrEqual
    )
}

public func == (lhs: MortarCoordinate, rhs: MortarCoordinateConvertible) -> MortarConstraintGroup {
    .init(
        target: lhs,
        source: rhs.coordinate,
        relation: .equal
    )
}

public func >= (lhs: MortarCoordinate, rhs: MortarCoordinateConvertible) -> MortarConstraintGroup {
    .init(
        target: lhs,
        source: rhs.coordinate,
        relation: .greaterThanOrEqual
    )
}

public func <= (lhs: MortarCoordinate, rhs: MortarCoordinateConvertible) -> MortarConstraintGroup {
    .init(
        target: lhs,
        source: rhs.coordinate,
        relation: .lessThanOrEqual
    )
}

public func == (lhs: MortarSizeCoordinate, rhs: MortarSizeCoordinate) -> MortarConstraintGroup {
    .init(
        target: lhs.coordinate,
        source: rhs.coordinate,
        relation: .equal
    )
}

public func >= (lhs: MortarSizeCoordinate, rhs: MortarSizeCoordinate) -> MortarConstraintGroup {
    .init(
        target: lhs.coordinate,
        source: rhs.coordinate,
        relation: .greaterThanOrEqual
    )
}

public func <= (lhs: MortarSizeCoordinate, rhs: MortarSizeCoordinate) -> MortarConstraintGroup {
    .init(
        target: lhs.coordinate,
        source: rhs.coordinate,
        relation: .lessThanOrEqual
    )
}

public func == (lhs: MortarSizeCoordinate, rhs: MortarSizeCoordinateConvertible) -> MortarConstraintGroup {
    .init(
        target: lhs.coordinate,
        source: rhs.coordinate.coordinate,
        relation: .equal
    )
}

public func >= (lhs: MortarSizeCoordinate, rhs: MortarSizeCoordinateConvertible) -> MortarConstraintGroup {
    .init(
        target: lhs.coordinate,
        source: rhs.coordinate.coordinate,
        relation: .greaterThanOrEqual
    )
}

public func <= (lhs: MortarSizeCoordinate, rhs: MortarSizeCoordinateConvertible) -> MortarConstraintGroup {
    .init(
        target: lhs.coordinate,
        source: rhs.coordinate.coordinate,
        relation: .lessThanOrEqual
    )
}
