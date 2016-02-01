//
//  Cement.swift
//  MortarTest
//
//  Created by Jason Fieldman on 1/30/16.
//  Copyright © 2016 Jason Fieldman. All rights reserved.
//

import Foundation
import UIKit

// Viewscape
// Mortar




internal enum MortarLayoutAttribute {
    case Left
    case Right
    case Top
    case Bottom
    case Leading
    case Trailing
    case Width
    case Height
    case CenterX
    case CenterY
    case Baseline
    case FirstBaseline
    case LeftMargin
    case RightMargin
    case TopMargin
    case BottomMargin
    case LeadingMargin
    case TrailingMargin
    case CenterXWithinMargins
    case CenterYWithinMargins
    case NotAnAttribute
    case Sides
    case Caps
    case Size
    case CornerTL
    case CornerTR
    case CornerBL
    case CornerBR
    case Edges
    case Frame
    case Center
    
    func nsLayoutAttribute() -> NSLayoutAttribute? {
        switch self {
        case .Left:                     return .Left
        case .Right:                    return .Right
        case .Top:                      return .Top
        case .Bottom:                   return .Bottom
        case .Leading:                  return .Leading
        case .Trailing:                 return .Trailing
        case .Width:                    return .Width
        case .Height:                   return .Height
        case .CenterX:                  return .CenterX
        case .CenterY:                  return .CenterY
        case .Baseline:                 return .Baseline
        case .FirstBaseline:            return .FirstBaseline
        case .LeftMargin:               return .LeftMargin
        case .RightMargin:              return .RightMargin
        case .TopMargin:                return .TopMargin
        case .BottomMargin:             return .BottomMargin
        case .LeadingMargin:            return .LeadingMargin
        case .TrailingMargin:           return .TrailingMargin
        case .CenterXWithinMargins:     return .CenterXWithinMargins
        case .CenterYWithinMargins:     return .CenterYWithinMargins
        case .NotAnAttribute:           return .NotAnAttribute
        default:                        return nil
        }
    }
    
    func componentAttributes() -> [MortarLayoutAttribute] {
        switch self {
        case .Left:                     return [.Left                                   ]
        case .Right:                    return [.Right                                  ]
        case .Top:                      return [.Top                                    ]
        case .Bottom:                   return [.Bottom                                 ]
        case .Leading:                  return [.Leading                                ]
        case .Trailing:                 return [.Trailing                               ]
        case .Width:                    return [.Width                                  ]
        case .Height:                   return [.Height                                 ]
        case .CenterX:                  return [.CenterX                                ]
        case .CenterY:                  return [.CenterY                                ]
        case .Baseline:                 return [.Baseline                               ]
        case .FirstBaseline:            return [.FirstBaseline                          ]
        case .LeftMargin:               return [.LeftMargin                             ]
        case .RightMargin:              return [.RightMargin                            ]
        case .TopMargin:                return [.TopMargin                              ]
        case .BottomMargin:             return [.BottomMargin                           ]
        case .LeadingMargin:            return [.LeadingMargin                          ]
        case .TrailingMargin:           return [.TrailingMargin                         ]
        case .CenterXWithinMargins:     return [.CenterXWithinMargins                   ]
        case .CenterYWithinMargins:     return [.CenterYWithinMargins                   ]
        case .NotAnAttribute:           return [.NotAnAttribute                         ]
            
        case .Sides:                    return [.Left,    .Right                        ]
        case .Caps:                     return [.Top,     .Bottom                       ]
        case .Size:                     return [.Width,   .Height                       ]
        case .CornerTL:                 return [.Top,     .Left                         ]
        case .CornerTR:                 return [.Top,     .Right                        ]
        case .CornerBL:                 return [.Bottom,  .Left                         ]
        case .CornerBR:                 return [.Bottom,  .Right                        ]
        case .Edges:                    return [.Top,     .Left,    .Bottom,  .Right    ]
        case .Frame:                    return [.Top,     .Left,    .Width,   .Height   ]
        case .Center:                   return [.CenterX, .CenterY                      ]            
        }
    }
    
    func implicitSuperviewBaseline() -> NSLayoutAttribute {
        switch self {
        case .Left:                     return .Left
        case .Right:                    return .Left
        case .Top:                      return .Top
        case .Bottom:                   return .Top
        case .CenterX:                  return .Left
        case .CenterY:                  return .Top
        case .CenterXWithinMargins:     return .Left
        case .CenterYWithinMargins:     return .Top
        default:                        return .NotAnAttribute
        }
    }
}

let UILayoutPriorityDefault = (UILayoutPriorityDefaultHigh + UILayoutPriorityDefaultLow) / 2.0

public protocol MortarCGFloatable {
    @inline(__always) func m_cgfloatValue() -> CGFloat
}

extension CGFloat : MortarCGFloatable {
    @inline(__always) public func m_cgfloatValue() -> CGFloat {
        return self
    }
}

extension Int : MortarCGFloatable {
    @inline(__always) public func m_cgfloatValue() -> CGFloat {
        return CGFloat(self)
    }
}

extension Double : MortarCGFloatable {
    @inline(__always) public func m_cgfloatValue() -> CGFloat {
        return CGFloat(self)
    }
}

extension Float : MortarCGFloatable {
    @inline(__always) public func m_cgfloatValue() -> CGFloat {
        return CGFloat(self)
    }
}


public protocol MortarAttributable {
    @inline(__always) func m_intoAttribute() -> MortarAttribute
}

extension CGFloat : MortarAttributable {
    @inline(__always) public func m_intoAttribute() -> MortarAttribute {
        return MortarAttribute(constant: self)
    }
}

extension Int : MortarAttributable {
    @inline(__always) public func m_intoAttribute() -> MortarAttribute {
        return MortarAttribute(constant: self)
    }
}

extension Double : MortarAttributable {
    @inline(__always) public func m_intoAttribute() -> MortarAttribute {
        return MortarAttribute(constant: self)
    }
}

extension Float : MortarAttributable {
    @inline(__always) public func m_intoAttribute() -> MortarAttribute {
        return MortarAttribute(constant: self)
    }
}

extension UIView : MortarAttributable {
    @inline(__always) public func m_intoAttribute() -> MortarAttribute {
        return MortarAttribute(view: self)
    }
}

extension MortarAttribute : MortarAttributable {
    @inline(__always) public func m_intoAttribute() -> MortarAttribute {
        return self
    }
}

public typealias MortarTwople  = (MortarAttributable, MortarAttributable)
public typealias MortarFourple = (MortarAttributable, MortarAttributable, MortarAttributable, MortarAttributable)
public typealias MortarTuple   = [MortarAttribute]

@inline(__always) internal func MortarConvertTwople(twople: MortarTwople) -> MortarTuple {
    return [twople.0.m_intoAttribute(), twople.1.m_intoAttribute()]
}

@inline(__always) internal func MortarConvertFourple(fourple: MortarFourple) -> MortarTuple {
    return [fourple.0.m_intoAttribute(), fourple.1.m_intoAttribute(), fourple.2.m_intoAttribute(), fourple.3.m_intoAttribute()]
}

