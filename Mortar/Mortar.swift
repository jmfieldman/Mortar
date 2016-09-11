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
    case left
    case right
    case top
    case bottom
    case leading
    case trailing
    case width
    case height
    case centerX
    case centerY
    case baseline
    #if os(iOS) || os(tvOS)
    case firstBaseline
    case lastBaseline
    case leftMargin
    case rightMargin
    case topMargin
    case bottomMargin
    case leadingMargin
    case trailingMargin
    case centerXWithinMargins
    case centerYWithinMargins
    #endif
    case notAnAttribute
    case sides
    case caps
    case size
    case cornerTL
    case cornerTR
    case cornerBL
    case cornerBR
    case edges
    case frame
    case center
    
    #if os(iOS) || os(tvOS)
    func nsLayoutAttribute() -> NSLayoutAttribute? {
        if #available(iOS 8.0, *) {
            switch self {
            case .left:                     return .left
            case .right:                    return .right
            case .top:                      return .top
            case .bottom:                   return .bottom
            case .leading:                  return .leading
            case .trailing:                 return .trailing
            case .width:                    return .width
            case .height:                   return .height
            case .centerX:                  return .centerX
            case .centerY:                  return .centerY
            case .baseline:                 return .lastBaseline
            case .firstBaseline:            return .firstBaseline
            case .lastBaseline:             return .lastBaseline
            case .leftMargin:               return .leftMargin
            case .rightMargin:              return .rightMargin
            case .topMargin:                return .topMargin
            case .bottomMargin:             return .bottomMargin
            case .leadingMargin:            return .leadingMargin
            case .trailingMargin:           return .trailingMargin
            case .centerXWithinMargins:     return .centerXWithinMargins
            case .centerYWithinMargins:     return .centerYWithinMargins
            case .notAnAttribute:           return .notAnAttribute
            default:                        return nil
            }
        } else {

            switch self {
            case .left:                     return .left
            case .right:                    return .right
            case .top:                      return .top
            case .bottom:                   return .bottom
            case .leading:                  return .leading
            case .trailing:                 return .trailing
            case .width:                    return .width
            case .height:                   return .height
            case .centerX:                  return .centerX
            case .centerY:                  return .centerY
            case .baseline:                 return .lastBaseline
            case .notAnAttribute:           return .notAnAttribute
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
        case .left:                     return [.left                                   ]
        case .right:                    return [.right                                  ]
        case .top:                      return [.top                                    ]
        case .bottom:                   return [.bottom                                 ]
        case .leading:                  return [.leading                                ]
        case .trailing:                 return [.trailing                               ]
        case .width:                    return [.width                                  ]
        case .height:                   return [.height                                 ]
        case .centerX:                  return [.centerX                                ]
        case .centerY:                  return [.centerY                                ]
        case .baseline:                 return [.lastBaseline                           ]
        case .firstBaseline:            return [.firstBaseline                          ]
        case .lastBaseline:             return [.lastBaseline                           ]
        case .leftMargin:               return [.leftMargin                             ]
        case .rightMargin:              return [.rightMargin                            ]
        case .topMargin:                return [.topMargin                              ]
        case .bottomMargin:             return [.bottomMargin                           ]
        case .leadingMargin:            return [.leadingMargin                          ]
        case .trailingMargin:           return [.trailingMargin                         ]
        case .centerXWithinMargins:     return [.centerXWithinMargins                   ]
        case .centerYWithinMargins:     return [.centerYWithinMargins                   ]
        case .notAnAttribute:           return [.notAnAttribute                         ]
            
        case .sides:                    return [.left,    .right                        ]
        case .caps:                     return [.top,     .bottom                       ]
        case .size:                     return [.width,   .height                       ]
        case .cornerTL:                 return [.top,     .left                         ]
        case .cornerTR:                 return [.top,     .right                        ]
        case .cornerBL:                 return [.bottom,  .left                         ]
        case .cornerBR:                 return [.bottom,  .right                        ]
        case .edges:                    return [.top,     .left,    .bottom,  .right    ]
        case .frame:                    return [.left,    .top,     .width,   .height   ]
        case .center:                   return [.centerX, .centerY                      ]            
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
        case .left:                     return .left
        case .right:                    return .left
        case .top:                      return .top
        case .bottom:                   return .top
        case .centerX:                  return .left
        case .centerY:                  return .top
        case .centerXWithinMargins:     return .left
        case .centerYWithinMargins:     return .top
        default:                        return .notAnAttribute
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
        case .right:                    return -1
        case .bottom:                   return -1
        default:                        return 1
        }
    }
}

public enum MortarLayoutPriority {
    case low, `default`, high, required
    
    public func layoutPriority() -> MortarAliasLayoutPriority {
        switch self {
        case .low:      return MortarAliasLayoutPriorityDefaultLow
        case .default:  return MortarAliasLayoutPriorityDefaultNormal
        case .high:     return MortarAliasLayoutPriorityDefaultHigh
        case .required: return MortarAliasLayoutPriorityDefaultRequired
        }
    }
}

public enum MortarActivationState {
    case activated, deactivated
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

@inline(__always) internal func MortarConvertTwople(_ twople: MortarTwople) -> MortarTuple {
    return ([twople.0.m_intoAttribute(), twople.1.m_intoAttribute()], MortarDefault.priority.current())
}

@inline(__always) internal func MortarConvertFourple(_ fourple: MortarFourple) -> MortarTuple {
    return ([fourple.0.m_intoAttribute(), fourple.1.m_intoAttribute(), fourple.2.m_intoAttribute(), fourple.3.m_intoAttribute()], MortarDefault.priority.current())
}





