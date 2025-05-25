//
//  MortarConstraint.swift
//  Copyright © 2016 Jason Fieldman.
//

import CombineEx

/// A `MortarConstraint` binds a target and source together with a relation (=, <=, >=).
/// This constraint coordinates must represent non-virtual, single-sub-attribute
/// values with the same theme (position, size, axis).
public struct MortarConstraint {
    let target: MortarCoordinate
    let source: MortarCoordinate
    let relation: MortarAliasLayoutRelation

    init(
        target: MortarCoordinate,
        source: MortarCoordinate,
        relation: MortarAliasLayoutRelation
    ) {
        self.target = target
        self.source = source
        self.relation = relation
    }
}
