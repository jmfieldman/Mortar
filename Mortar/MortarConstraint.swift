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

    /// The resolved NSLayoutConstraint
    let layoutConstraint: NSLayoutConstraint?

    init(
        target: MortarCoordinate,
        source: MortarCoordinate,
        relation: MortarAliasLayoutRelation
    ) {
        self.target = target
        self.source = source
        self.relation = relation

        guard
            let targetItem = target.item,
            let targetAttribute = target.attribute,
            let targetStandardAttribute = targetAttribute.standardLayoutAttribute
        else {
            self.layoutConstraint = nil
            return
        }

        self.layoutConstraint = NSLayoutConstraint(
            item: targetItem,
            attribute: targetStandardAttribute,
            relatedBy: relation,
            toItem: source.item,
            attribute: source.attribute?.standardLayoutAttribute ?? targetStandardAttribute,
            multiplier: source.multiplier,
            constant: source.constant.0
        )
    }
}
