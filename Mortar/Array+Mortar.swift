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


public extension Array where Element: MortarView {

    var m_left:                 [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .left                   }); return z }
    var m_right:                [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .right                  }); return z }
    var m_top:                  [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .top                    }); return z }
    var m_bottom:               [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .bottom                 }); return z }
    var m_leading:              [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .leading                }); return z }
    var m_trailing:             [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .trailing               }); return z }
    var m_width:                [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .width                  }); return z }
    var m_height:               [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .height                 }); return z }
    var m_centerX:              [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .centerX                }); return z }
    var m_centerY:              [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .centerY                }); return z }
    var m_baseline:             [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .baseline               }); return z }
    #if os(iOS) || os(tvOS)
    var m_firstBaseline:        [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .firstBaseline          }); return z }
    var m_leftMargin:           [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .leftMargin             }); return z }
    var m_rightMargin:          [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .rightMargin            }); return z }
    var m_topMargin:            [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .topMargin              }); return z }
    var m_bottomMargin:         [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .bottomMargin           }); return z }
    var m_leadingMargin:        [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .leadingMargin          }); return z }
    var m_trailingMargin:       [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .trailingMargin         }); return z }
    var m_centerXWithinMargin:  [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .centerXWithinMargins   }); return z }
    var m_centerYWithinMargin:  [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .centerYWithinMargins   }); return z }
    #endif
    var m_sides:                [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .sides                  }); return z }
    var m_caps:                 [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .caps                   }); return z }
    var m_size:                 [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .size                   }); return z }
    var m_cornerTL:             [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .cornerTL               }); return z }
    var m_cornerTR:             [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .cornerTR               }); return z }
    var m_cornerBL:             [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .cornerBL               }); return z }
    var m_cornerBR:             [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .cornerBR               }); return z }
    var m_edges:                [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .edges                  }); return z }
    var m_frame:                [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .frame                  }); return z }
    var m_center:               [MortarAttribute] { let z = self.map({ $0.m_intoAttribute() }); z.forEach({$0.attribute = .center                 }); return z }
    
}
