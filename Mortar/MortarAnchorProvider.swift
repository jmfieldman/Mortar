//
//  MortarAnchorProvider.swift
//  Copyright © 2025 Jason Fieldman.
//

public struct MortarAnchorProvider {
    let item: AnyObject

    func anchorCoordinate(_ attribute: MortarLayoutAttribute) -> MortarCoordinate {
        .init(
            item: item,
            attribute: attribute,
            multiplier: 1,
            constant: (0, 0, 0, 0),
            priority: .required
        )
    }
}

public extension MortarAnchorProvider {
    var left: MortarCoordinate { anchorCoordinate(.left) }
    var right: MortarCoordinate { anchorCoordinate(.right) }
    var top: MortarCoordinate { anchorCoordinate(.top) }
    var bottom: MortarCoordinate { anchorCoordinate(.bottom) }
    var leading: MortarCoordinate { anchorCoordinate(.leading) }
    var trailing: MortarCoordinate { anchorCoordinate(.trailing) }
    var centerX: MortarCoordinate { anchorCoordinate(.centerX) }
    var centerY: MortarCoordinate { anchorCoordinate(.centerY) }
    var baseline: MortarCoordinate { anchorCoordinate(.baseline) }
    var firstBaseline: MortarCoordinate { anchorCoordinate(.firstBaseline) }
    var lastBaseline: MortarCoordinate { anchorCoordinate(.lastBaseline) }
    var size: MortarCoordinate { anchorCoordinate(.size) }
    var width: MortarCoordinate { anchorCoordinate(.width) }
    var height: MortarCoordinate { anchorCoordinate(.height) }

    #if os(iOS) || os(tvOS)
    var leftMargin: MortarCoordinate { anchorCoordinate(.leftMargin) }
    var rightMargin: MortarCoordinate { anchorCoordinate(.rightMargin) }
    var topMargin: MortarCoordinate { anchorCoordinate(.topMargin) }
    var bottomMargin: MortarCoordinate { anchorCoordinate(.bottomMargin) }
    var leadingMargin: MortarCoordinate { anchorCoordinate(.leadingMargin) }
    var trailingMargin: MortarCoordinate { anchorCoordinate(.trailingMargin) }
    var centerXWithinMargins: MortarCoordinate { anchorCoordinate(.centerXWithinMargins) }
    var centerYWithinMargins: MortarCoordinate { anchorCoordinate(.centerYWithinMargins) }
    #endif

    var sides: MortarCoordinate { anchorCoordinate(.sides) }
    var caps: MortarCoordinate { anchorCoordinate(.caps) }
    var topLeft: MortarCoordinate { anchorCoordinate(.topLeft) }
    var topLeading: MortarCoordinate { anchorCoordinate(.topLeading) }
    var topRight: MortarCoordinate { anchorCoordinate(.topRight) }
    var topTrailing: MortarCoordinate { anchorCoordinate(.topTrailing) }
    var bottomLeft: MortarCoordinate { anchorCoordinate(.bottomLeft) }
    var bottomLeading: MortarCoordinate { anchorCoordinate(.bottomLeading) }
    var bottomRight: MortarCoordinate { anchorCoordinate(.bottomRight) }
    var bottomTrailing: MortarCoordinate { anchorCoordinate(.bottomTrailing) }
    var edges: MortarCoordinate { anchorCoordinate(.edges) }
    var center: MortarCoordinate { anchorCoordinate(.center) }
}
