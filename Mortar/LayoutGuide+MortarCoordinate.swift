//
//  LayoutGuide+MortarCoordinate.swift
//  Copyright © 2025 Jason Fieldman.
//

public extension MortarLayoutGuide {
    var anchors: MortarAnchorProvider {
        .init(item: self)
    }

    var size: MortarSizeCoordinate {
        .init(
            item: self,
            multiplier: 1,
            constant: .zero,
            priority: .required
        )
    }
}
