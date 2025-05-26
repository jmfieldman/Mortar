//
//  MortarConstraintGroup.swift
//  Copyright © 2016 Jason Fieldman.
//

import CombineEx

/// A `MortarConstraintGroup` is a collection of `MortarConstraint` objects bound by
/// a single virtual expression.
public struct MortarConstraintGroup {
    let constraints: [MortarConstraint]

    init(constraints: [MortarConstraint]) {
        self.constraints = constraints
    }

    init(
        target: MortarCoordinate,
        source: MortarCoordinate,
        relation: MortarAliasLayoutRelation
    ) {
        self.constraints = []
    }
}
