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

import Foundation


public extension Array where Element: MortarAttributable {
    
    public var m_left:                  [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .Left                   }); return z }
    public var m_right:                 [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .Right                  }); return z }
    public var m_top:                   [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .Top                    }); return z }
    public var m_bottom:                [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .Bottom                 }); return z }
    public var m_leading:               [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .Leading                }); return z }
    public var m_trailing:              [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .Trailing               }); return z }
    public var m_width:                 [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .Width                  }); return z }
    public var m_height:                [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .Height                 }); return z }
    public var m_centerX:               [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .CenterX                }); return z }
    public var m_centerY:               [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .CenterY                }); return z }
    public var m_baseline:              [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .Baseline               }); return z }
    public var m_firstBaseline:         [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .FirstBaseline          }); return z }
    public var m_leftMargin:            [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .LeftMargin             }); return z }
    public var m_rightMargin:           [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .RightMargin            }); return z }
    public var m_topMargin:             [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .TopMargin              }); return z }
    public var m_bottomMargin:          [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .BottomMargin           }); return z }
    public var m_leadingMargin:         [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .LeadingMargin          }); return z }
    public var m_trailingMargin:        [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .TrailingMargin         }); return z }
    public var m_centerXWithinMargin:   [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .CenterXWithinMargins   }); return z }
    public var m_centerYWithinMargin:   [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .CenterYWithinMargins   }); return z }
    public var m_sides:                 [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .Sides                  }); return z }
    public var m_caps:                  [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .Caps                   }); return z }
    public var m_size:                  [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .Size                   }); return z }
    public var m_cornerTL:              [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .CornerTL               }); return z }
    public var m_cornerTR:              [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .CornerTR               }); return z }
    public var m_cornerBL:              [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .CornerBL               }); return z }
    public var m_cornerBR:              [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .CornerBR               }); return z }
    public var m_edges:                 [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .Edges                  }); return z }
    public var m_frame:                 [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .Frame                  }); return z }
    public var m_center:                [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .Center                 }); return z }
    
}
