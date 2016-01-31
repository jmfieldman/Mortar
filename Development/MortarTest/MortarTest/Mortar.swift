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
}



public protocol Mortar_CGFloatable {
    @inline(__always) func m_cgfloatValue() -> CGFloat
}

extension CGFloat : Mortar_CGFloatable {
    @inline(__always) public func m_cgfloatValue() -> CGFloat {
        return self
    }
}

extension Int : Mortar_CGFloatable {
    @inline(__always) public func m_cgfloatValue() -> CGFloat {
        return CGFloat(self)
    }
}

extension Double : Mortar_CGFloatable {
    @inline(__always) public func m_cgfloatValue() -> CGFloat {
        return CGFloat(self)
    }
}

extension Float : Mortar_CGFloatable {
    @inline(__always) public func m_cgfloatValue() -> CGFloat {
        return CGFloat(self)
    }
}



