//
//  View+MortarCoordinate.swift
//  Copyright © 2025 Jason Fieldman.
//

public extension MortarView {
    var layout: MortarAnchorProvider {
        .init(item: self)
    }

    var parentLayout: MortarAnchorProvider {
        .init(item: MortarRelativeAnchor.parent(self))
    }

    func referencedLayout(_ referenceId: String) -> MortarAnchorProvider {
        .init(item: MortarRelativeAnchor.reference(referenceId))
    }

    var layoutReferenceId: String? {
        get {
            MortarMainThreadLayoutStack.shared.layoutReferenceIdFor(view: self)
        }
        set {
            MortarMainThreadLayoutStack.shared.addLayoutReference(id: newValue, view: self)
        }
    }
}
