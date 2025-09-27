//
//  View+MortarCoordinate.swift
//  Copyright © 2025 Jason Fieldman.
//

public extension MortarView {
    var layout: MortarAnchorProvider {
        .init(item: self)
    }

    var safeLayout: MortarAnchorProvider {
        .init(item: safeAreaLayoutGuide)
    }

    var keyboardLayout: MortarAnchorProvider {
        .init(item: keyboardLayoutGuide)
    }

    var parentLayout: MortarAnchorProvider {
        .init(item: MortarRelativeAnchor.parent(self) { $0 })
    }

    var parentSafeAreaLayout: MortarAnchorProvider {
        .init(item: MortarRelativeAnchor.parent(self) { $0.safeAreaLayoutGuide })
    }

    var parentKeyboardLayout: MortarAnchorProvider {
        .init(item: MortarRelativeAnchor.parent(self) { $0.keyboardLayoutGuide })
    }

    func referencedLayout(_ referenceId: String) -> MortarAnchorProvider {
        .init(item: MortarRelativeAnchor.reference(referenceId) { $0 })
    }

    func referencedSafeAreaLayout(_ referenceId: String) -> MortarAnchorProvider {
        .init(item: MortarRelativeAnchor.reference(referenceId) { $0.safeAreaLayoutGuide })
    }

    func referencedLeyboardLayout(_ referenceId: String) -> MortarAnchorProvider {
        .init(item: MortarRelativeAnchor.reference(referenceId) { $0.keyboardLayoutGuide })
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
