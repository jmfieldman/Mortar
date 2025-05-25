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
public typealias MortarLayoutGuide = UILayoutGuide
public typealias MortarAliasLayoutPriority = UILayoutPriority
public typealias MortarAliasLayoutRelation = NSLayoutConstraint.Relation
public typealias MortarAliasLayoutAttribute = NSLayoutConstraint.Attribute
#else
import AppKit
public typealias MortarView = NSView
public typealias MortarLayoutGuide = NSLayoutGuide
public typealias MortarAliasLayoutPriority = NSLayoutConstraint.Priority
public typealias MortarAliasLayoutRelation = NSLayoutConstraint.Relation
public typealias MortarAliasLayoutAttribute = NSLayoutConstraint.Attribute
#endif

public enum MortarAxis {
    case horizontal, vertical
}

public enum MortarActivationState {
    case activated, deactivated
}

/// Defines the virtual Mortar-specific attributes, which allow for custom
/// attributes that represent multuple sub-attributes.
internal enum MortarLayoutAttribute {
    enum LayoutType {
        case position, size
    }
    
    // Standard attributes
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
    case firstBaseline
    case lastBaseline
    case notAnAttribute
    
    // iOS/tvOS-specific attributes
    #if os(iOS) || os(tvOS)
    case leftMargin
    case rightMargin
    case topMargin
    case bottomMargin
    case leadingMargin
    case trailingMargin
    case centerXWithinMargins
    case centerYWithinMargins
    #endif
    
    // Attributes with multiple sub-attributes
    case sides
    case caps
    case size
    case topLeft
    case topLeading
    case topRight
    case topTrailing
    case bottomLeft
    case bottomLeading
    case bottomRight
    case bottomTrailing
    case edges
    case frame
    case center
    
    #if os(iOS) || os(tvOS)
    var standardLayoutAttribute: MortarAliasLayoutAttribute? {
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
    }
    #else
    var standardLayoutAttribute: MortarAliasLayoutAttribute? {
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
        case .notAnAttribute:           return .notAnAttribute
        default:                        return nil
        }
    }
    #endif
    
    #if os(iOS) || os(tvOS)
    var axis: MortarAxis? {
        switch self {
        case .left:                     return .horizontal
        case .right:                    return .horizontal
        case .top:                      return .vertical
        case .bottom:                   return .vertical
        case .leading:                  return .horizontal
        case .trailing:                 return .horizontal
        case .width:                    return .horizontal
        case .height:                   return .vertical
        case .centerX:                  return .horizontal
        case .centerY:                  return .vertical
        case .baseline:                 return .vertical
        case .firstBaseline:            return .vertical
        case .lastBaseline:             return .vertical
        case .leftMargin:               return .horizontal
        case .rightMargin:              return .horizontal
        case .topMargin:                return .vertical
        case .bottomMargin:             return .vertical
        case .leadingMargin:            return .horizontal
        case .trailingMargin:           return .horizontal
        case .centerXWithinMargins:     return .horizontal
        case .centerYWithinMargins:     return .vertical
        default:                        return nil
        }
    }
    #else
    var axis: MortarAxis? {
        switch self {
        case .left:                     return .horizontal
        case .right:                    return .horizontal
        case .top:                      return .vertical
        case .bottom:                   return .vertical
        case .leading:                  return .horizontal
        case .trailing:                 return .horizontal
        case .width:                    return .horizontal
        case .height:                   return .vertical
        case .centerX:                  return .horizontal
        case .centerY:                  return .vertical
        case .baseline:                 return .vertical
        case .firstBaseline:            return .vertical
        case .lastBaseline:             return .vertical
        default:                        return nil
        }
    }
    #endif
    
    #if os(iOS) || os(tvOS)
    var layoutType: LayoutType? {
        switch self {
        case .left:                     return .position
        case .right:                    return .position
        case .top:                      return .position
        case .bottom:                   return .position
        case .leading:                  return .position
        case .trailing:                 return .position
        case .width:                    return .size
        case .height:                   return .size
        case .centerX:                  return .position
        case .centerY:                  return .position
        case .baseline:                 return .position
        case .firstBaseline:            return .position
        case .lastBaseline:             return .position
        case .leftMargin:               return .position
        case .rightMargin:              return .position
        case .topMargin:                return .position
        case .bottomMargin:             return .position
        case .leadingMargin:            return .position
        case .trailingMargin:           return .position
        case .centerXWithinMargins:     return .position
        case .centerYWithinMargins:     return .position
        default:                        return nil
        }
    }
    #else
    var layoutType: LayoutType? {
        switch self {
        case .left:                     return .position
        case .right:                    return .position
        case .top:                      return .position
        case .bottom:                   return .position
        case .leading:                  return .position
        case .trailing:                 return .position
        case .width:                    return .size
        case .height:                   return .size
        case .centerX:                  return .position
        case .centerY:                  return .position
        case .baseline:                 return .position
        case .firstBaseline:            return .position
        case .lastBaseline:             return .position
        default:                        return nil
        }
    }
    #endif
    
    #if os(iOS) || os(tvOS)
    var componentAttributes: [MortarAliasLayoutAttribute] {
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
            
        case .sides:                    return [.leading, .trailing                     ]
        case .caps:                     return [.top,     .bottom                       ]
        case .size:                     return [.width,   .height                       ]
        case .topLeft:                  return [.top,     .left                         ]
        case .topLeading:               return [.top,     .leading                      ]
        case .topRight:                 return [.top,     .right                        ]
        case .topTrailing:              return [.top,     .trailing                     ]
        case .bottomLeft:               return [.bottom,  .left                         ]
        case .bottomLeading:            return [.bottom,  .leading                      ]
        case .bottomRight:              return [.bottom,  .right                        ]
        case .bottomTrailing:           return [.bottom,  .trailing                     ]
        case .edges:                    return [.top,     .leading, .bottom,  .trailing ]
        case .frame:                    return [.leading, .top,     .width,   .height   ]
        case .center:                   return [.centerX, .centerY                      ]
        }
    }
    #else
    var componentAttributes: [MortarAliasLayoutAttribute] {
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
        case .baseline:                 return [.baseline                               ]
        case .firstBaseline:            return [.firstBaseline                          ]
        case .lastBaseline:             return [.lastBaseline                           ]
        case .notAnAttribute:           return [.notAnAttribute                         ]
        
        case .sides:                    return [.leading, .trailing                     ]
        case .caps:                     return [.top,     .bottom                       ]
        case .size:                     return [.width,   .height                       ]
        case .topLeft:                  return [.top,     .left                         ]
        case .topLeading:               return [.top,     .leading                      ]
        case .topRight:                 return [.top,     .right                        ]
        case .topTrailing:              return [.top,     .trailing                     ]
        case .bottomLeft:               return [.bottom,  .left                         ]
        case .bottomLeading:            return [.bottom,  .leading                      ]
        case .bottomRight:              return [.bottom,  .right                        ]
        case .bottomTrailing:           return [.bottom,  .trailing                     ]
        case .edges:                    return [.top,     .leading, .bottom,  .trailing ]
        case .frame:                    return [.leading, .top,     .width,   .height   ]
        case .center:                   return [.centerX, .centerY                      ]
        }
    }
    #endif
}

public enum MortarLayoutPriority {
    case low, medium, high, req, priority(Int)
    
    @inline(__always) public func layoutPriority() -> MortarAliasLayoutPriority {
        switch self {
        case .low: return MortarAliasLayoutPriority.defaultLow
        case .medium: return MortarAliasLayoutPriority(rawValue: (Float(MortarAliasLayoutPriority.defaultHigh.rawValue) + Float(MortarAliasLayoutPriority.defaultLow.rawValue)) / 2)
        case .high: return MortarAliasLayoutPriority.defaultHigh
        case .req: return MortarAliasLayoutPriority.required
        case .priority(let value): return MortarAliasLayoutPriority(rawValue: Float(value))
        }
    }
}




