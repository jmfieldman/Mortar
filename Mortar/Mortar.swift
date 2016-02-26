//
//  Mortar
//
//  Copyright (c) 2016-Present Jason Fieldman - https://github.com/jmfieldman/Mortar
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


#if os(iOS) || os(tvOS)
import UIKit
public typealias MortarView = UIView
public typealias MortarAliasLayoutPriority = UILayoutPriority

let MortarAliasLayoutPriorityDefaultLow      =  UILayoutPriorityDefaultLow
let MortarAliasLayoutPriorityDefaultNormal   = (UILayoutPriorityDefaultHigh + UILayoutPriorityDefaultLow) / 2
let MortarAliasLayoutPriorityDefaultHigh     =  UILayoutPriorityDefaultHigh
let MortarAliasLayoutPriorityDefaultRequired =  UILayoutPriorityRequired
    
#else
import AppKit
public typealias MortarView = NSView
public typealias MortarAliasLayoutPriority = NSLayoutPriority

let MortarAliasLayoutPriorityDefaultLow      =  NSLayoutPriorityDefaultLow
let MortarAliasLayoutPriorityDefaultNormal   = (NSLayoutPriorityDefaultHigh + NSLayoutPriorityDefaultLow) / 2
let MortarAliasLayoutPriorityDefaultHigh     =  NSLayoutPriorityDefaultHigh
let MortarAliasLayoutPriorityDefaultRequired =  NSLayoutPriorityRequired

#endif


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
    #if os(iOS) || os(tvOS)
    case FirstBaseline
    case LeftMargin
    case RightMargin
    case TopMargin
    case BottomMargin
    case LeadingMargin
    case TrailingMargin
    case CenterXWithinMargins
    case CenterYWithinMargins
    #endif
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
    
    #if os(iOS) || os(tvOS)
    func nsLayoutAttribute() -> NSLayoutAttribute? {
        if #available(iOS 8.0, *) {
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
        } else {

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
            case .NotAnAttribute:           return .NotAnAttribute
            default:                        return nil
            }
        }
    }
    #else
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
        case .NotAnAttribute:           return .NotAnAttribute
        default:                        return nil
        }
    }
    #endif
    
    #if os(iOS) || os(tvOS)
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
        case .Frame:                    return [.Left,    .Top,     .Width,   .Height   ]
        case .Center:                   return [.CenterX, .CenterY                      ]            
        }
    }
    #else
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
        case .NotAnAttribute:           return [.NotAnAttribute                         ]
        
        case .Sides:                    return [.Left,    .Right                        ]
        case .Caps:                     return [.Top,     .Bottom                       ]
        case .Size:                     return [.Width,   .Height                       ]
        case .CornerTL:                 return [.Top,     .Left                         ]
        case .CornerTR:                 return [.Top,     .Right                        ]
        case .CornerBL:                 return [.Bottom,  .Left                         ]
        case .CornerBR:                 return [.Bottom,  .Right                        ]
        case .Edges:                    return [.Top,     .Left,    .Bottom,  .Right    ]
        case .Frame:                    return [.Left,    .Top,     .Width,   .Height   ]
        case .Center:                   return [.CenterX, .CenterY                      ]
        }
    }
    #endif
    
    #if os(iOS) || os(tvOS)
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
    #else
    func implicitSuperviewBaseline() -> NSLayoutAttribute {
        switch self {
        case .Left:                     return .Left
        case .Right:                    return .Left
        case .Top:                      return .Top
        case .Bottom:                   return .Top
        case .CenterX:                  return .Left
        case .CenterY:                  return .Top
        default:                        return .NotAnAttribute
        }
    }
    #endif
    
    func insetConstantModifier() -> CGFloat {
        switch self {
        case .Right:                    return -1
        case .Bottom:                   return -1
        default:                        return 1
        }
    }
}

public enum MortarLayoutPriority {
    case Low, Default, High, Required
    
    public func layoutPriority() -> MortarAliasLayoutPriority {
        switch self {
        case .Low:      return MortarAliasLayoutPriorityDefaultLow
        case .Default:  return MortarAliasLayoutPriorityDefaultNormal
        case .High:     return MortarAliasLayoutPriorityDefaultHigh
        case .Required: return MortarAliasLayoutPriorityDefaultRequired
        }
    }
}

public enum MortarActivationState {
    case Activated, Deactivated
}

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

extension UInt : MortarCGFloatable {
    @inline(__always) public func m_cgfloatValue() -> CGFloat {
        return CGFloat(self)
    }
}

extension Int64 : MortarCGFloatable {
    @inline(__always) public func m_cgfloatValue() -> CGFloat {
        return CGFloat(self)
    }
}

extension UInt64 : MortarCGFloatable {
    @inline(__always) public func m_cgfloatValue() -> CGFloat {
        return CGFloat(self)
    }
}

extension UInt32 : MortarCGFloatable {
    @inline(__always) public func m_cgfloatValue() -> CGFloat {
        return CGFloat(self)
    }
}

extension Int32 : MortarCGFloatable {
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

extension MortarView : MortarAttributable {
    @inline(__always) public func m_intoAttribute() -> MortarAttribute {
        return MortarAttribute(item: self)
    }
}

extension MortarAttribute : MortarAttributable {
    @inline(__always) public func m_intoAttribute() -> MortarAttribute {
        return self
    }
}

public typealias MortarConstTwo  = (MortarCGFloatable, MortarCGFloatable)
public typealias MortarConstFour = (MortarCGFloatable, MortarCGFloatable, MortarCGFloatable, MortarCGFloatable)

public typealias MortarTwople  = (MortarAttributable, MortarAttributable)
public typealias MortarFourple = (MortarAttributable, MortarAttributable, MortarAttributable, MortarAttributable)
public typealias MortarTuple   = ([MortarAttribute], MortarAliasLayoutPriority?)

@inline(__always) internal func MortarConvertTwople(twople: MortarTwople) -> MortarTuple {
    return ([twople.0.m_intoAttribute(), twople.1.m_intoAttribute()], MortarAliasLayoutPriorityDefaultNormal)
}

@inline(__always) internal func MortarConvertFourple(fourple: MortarFourple) -> MortarTuple {
    return ([fourple.0.m_intoAttribute(), fourple.1.m_intoAttribute(), fourple.2.m_intoAttribute(), fourple.3.m_intoAttribute()], MortarAliasLayoutPriorityDefaultNormal)
}

