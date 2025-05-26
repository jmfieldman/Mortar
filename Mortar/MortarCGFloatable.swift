//
//  MortarCGFloatable.swift
//  Copyright © 2025 Jason Fieldman.
//

public protocol MortarCGFloatable: MortarCoordinateConvertible {
    var floatValue: CGFloat { get }
}

extension CGFloat: MortarCGFloatable {
    public var floatValue: CGFloat { self }
}

extension Int: MortarCGFloatable {
    public var floatValue: CGFloat { CGFloat(self) }
}

extension UInt: MortarCGFloatable {
    public var floatValue: CGFloat { CGFloat(self) }
}

extension Int64: MortarCGFloatable {
    public var floatValue: CGFloat { CGFloat(self) }
}

extension UInt64: MortarCGFloatable {
    public var floatValue: CGFloat { CGFloat(self) }
}

extension UInt32: MortarCGFloatable {
    public var floatValue: CGFloat { CGFloat(self) }
}

extension Int32: MortarCGFloatable {
    public var floatValue: CGFloat { CGFloat(self) }
}

extension UInt16: MortarCGFloatable {
    public var floatValue: CGFloat { CGFloat(self) }
}

extension Int16: MortarCGFloatable {
    public var floatValue: CGFloat { CGFloat(self) }
}

extension UInt8: MortarCGFloatable {
    public var floatValue: CGFloat { CGFloat(self) }
}

extension Int8: MortarCGFloatable {
    public var floatValue: CGFloat { CGFloat(self) }
}

extension Double: MortarCGFloatable {
    public var floatValue: CGFloat { CGFloat(self) }
}

extension Float: MortarCGFloatable {
    public var floatValue: CGFloat { CGFloat(self) }
}
