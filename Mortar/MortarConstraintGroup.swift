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
        guard let targetItem = target.item else {
            MortarError.emit("Creating a MortarConstraintGroup requires a target item")
            self.constraints = []
            return
        }

        guard let targetAttribute = target.attribute else {
            MortarError.emit("Creating a MortarConstraintGroup requires a target attribute")
            self.constraints = []
            return
        }

        guard source.attribute == nil || source.attribute?.degree == targetAttribute.degree else {
            MortarError.emit("If a source attribute is explicitly provided, it must have the same degree as the target attribute")
            self.constraints = []
            return
        }

        // Construct component constraint array
        if targetAttribute.degree == 1 {
            self.constraints = [
                MortarConstraint(target: target, source: source, relation: relation),
            ]
        } else {
            // Decompose the multiple components into separate expressions
            self.constraints = (0 ..< targetAttribute.degree).map { index -> MortarConstraint in
                .init(
                    target: .init(
                        item: target.item,
                        attribute: .from(targetAttribute.componentAttributes[index]),
                        multiplier: target.multiplier,
                        constant: (tupleIndex(target.constant, index), 0, 0, 0),
                        priority: target.priority
                    ),
                    source: .init(
                        item: source.item,
                        attribute: source.attribute.flatMap { .from($0.componentAttributes[index]) },
                        multiplier: source.multiplier,
                        constant: (tupleIndex(source.constant, index), 0, 0, 0),
                        priority: source.priority
                    ),
                    relation: relation
                )
            }
        }

        // Turn off target `translatesAutoresizingMaskIntoConstraints` if it is a view
        if let targetView = targetItem as? MortarView {
            targetView.translatesAutoresizingMaskIntoConstraints = false
        }

        // We either activate the constraint now, or wait until the processing stack is complete
        if MortarMainThreadLayoutStack.shared.insideStack() {
            MortarMainThreadLayoutStack.shared.accumulate(constraints: constraints)
        } else {
            for constraint in constraints {
                constraint.layoutConstraint?.isActive = constraint.source.startActivated
            }
        }
    }
}
