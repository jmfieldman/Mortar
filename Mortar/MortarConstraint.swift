//
//  MortarConstraint.swift
//  Copyright © 2016 Jason Fieldman.
//

import CombineEx

/// A `MortarConstraint` binds a target and source together with a relation (=, <=, >=).
/// This constraint coordinates must represent non-virtual, single-sub-attribute
/// values with the same theme (position, size, axis).
public class MortarConstraint {
    let target: MortarCoordinate
    let source: MortarCoordinate
    let relation: MortarAliasLayoutRelation

    private let layoutConstraintBuilder: (() -> NSLayoutConstraint?)?
    private(set) lazy var layoutConstraint: NSLayoutConstraint? = layoutConstraintBuilder?()

    init(
        target: MortarCoordinate,
        source: MortarCoordinate,
        relation: MortarAliasLayoutRelation
    ) {
        self.target = target
        self.source = source
        self.relation = relation

        guard let targetItem = target.item as? MortarView else {
            MortarError.emit("Cannot create constraint for non-view target")
            self.layoutConstraintBuilder = nil
            return
        }

        guard
            let targetAttribute = target.attribute,
            let targetStandardAttribute = targetAttribute.standardLayoutAttribute
        else {
            MortarError.emit("Cannot create constraint without target attribute")
            self.layoutConstraintBuilder = nil
            return
        }

        self.layoutConstraintBuilder = {
            var resolvedSourceItem: Any?
            do {
                resolvedSourceItem = try resolveSourceItem(source.item)
            } catch {
                return nil
            }

            return NSLayoutConstraint(
                item: targetItem,
                attribute: targetStandardAttribute,
                relatedBy: relation,
                toItem: resolvedSourceItem,
                attribute: source.attribute?.standardLayoutAttribute ?? targetStandardAttribute,
                multiplier: source.multiplier,
                constant: source.constant.0
            )
        }
    }
}

private func resolveSourceItem(_ item: Any?) throws -> Any? {
    guard let item else {
        return nil
    }

    if let view = item as? MortarView {
        return view
    }

    if let guide = item as? MortarLayoutGuide {
        return guide
    }

    if let reference = item as? MortarRelativeAnchor {
        switch reference {
        case let .parent(view):
            guard let parent = view.superview else {
                MortarError.emit("Constraint source item must be a subview of a UIView")
                return nil
            }
            return parent
        case let .reference(referenceId):
            guard let referenceView = MortarMainThreadLayoutStack.shared.viewForLayoutReference(id: referenceId) else {
                MortarError.emit("Could not resolve layout referenceId [\(referenceId)]")
                return nil
            }
            return referenceView
        }
    }

    MortarError.emit("Invalid constraint source item")
    throw NSError(domain: "", code: 0, userInfo: nil)
}
