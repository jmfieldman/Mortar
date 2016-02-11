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
import UIKit



public extension UIView {
    
    public var m_left:                  MortarAttribute { get { return MortarAttribute(view: self, attribute: .Left                   ) } }
    public var m_right:                 MortarAttribute { get { return MortarAttribute(view: self, attribute: .Right                  ) } }
    public var m_top:                   MortarAttribute { get { return MortarAttribute(view: self, attribute: .Top                    ) } }
    public var m_bottom:                MortarAttribute { get { return MortarAttribute(view: self, attribute: .Bottom                 ) } }
    public var m_leading:               MortarAttribute { get { return MortarAttribute(view: self, attribute: .Leading                ) } }
    public var m_trailing:              MortarAttribute { get { return MortarAttribute(view: self, attribute: .Trailing               ) } }
    public var m_width:                 MortarAttribute { get { return MortarAttribute(view: self, attribute: .Width                  ) } }
    public var m_height:                MortarAttribute { get { return MortarAttribute(view: self, attribute: .Height                 ) } }
    public var m_centerX:               MortarAttribute { get { return MortarAttribute(view: self, attribute: .CenterX                ) } }
    public var m_centerY:               MortarAttribute { get { return MortarAttribute(view: self, attribute: .CenterY                ) } }
    public var m_baseline:              MortarAttribute { get { return MortarAttribute(view: self, attribute: .Baseline               ) } }
    public var m_firstBaseline:         MortarAttribute { get { return MortarAttribute(view: self, attribute: .FirstBaseline          ) } }
    public var m_leftMargin:            MortarAttribute { get { return MortarAttribute(view: self, attribute: .LeftMargin             ) } }
    public var m_rightMargin:           MortarAttribute { get { return MortarAttribute(view: self, attribute: .RightMargin            ) } }
    public var m_topMargin:             MortarAttribute { get { return MortarAttribute(view: self, attribute: .TopMargin              ) } }
    public var m_bottomMargin:          MortarAttribute { get { return MortarAttribute(view: self, attribute: .BottomMargin           ) } }
    public var m_leadingMargin:         MortarAttribute { get { return MortarAttribute(view: self, attribute: .LeadingMargin          ) } }
    public var m_trailingMargin:        MortarAttribute { get { return MortarAttribute(view: self, attribute: .TrailingMargin         ) } }
    public var m_centerXWithinMargin:   MortarAttribute { get { return MortarAttribute(view: self, attribute: .CenterXWithinMargins   ) } }
    public var m_centerYWithinMargin:   MortarAttribute { get { return MortarAttribute(view: self, attribute: .CenterYWithinMargins   ) } }
    public var m_sides:                 MortarAttribute { get { return MortarAttribute(view: self, attribute: .Sides                  ) } }
    public var m_caps:                  MortarAttribute { get { return MortarAttribute(view: self, attribute: .Caps                   ) } }
    public var m_size:                  MortarAttribute { get { return MortarAttribute(view: self, attribute: .Size                   ) } }
    public var m_cornerTL:              MortarAttribute { get { return MortarAttribute(view: self, attribute: .CornerTL               ) } }
    public var m_cornerTR:              MortarAttribute { get { return MortarAttribute(view: self, attribute: .CornerTR               ) } }
    public var m_cornerBL:              MortarAttribute { get { return MortarAttribute(view: self, attribute: .CornerBL               ) } }
    public var m_cornerBR:              MortarAttribute { get { return MortarAttribute(view: self, attribute: .CornerBR               ) } }
    public var m_edges:                 MortarAttribute { get { return MortarAttribute(view: self, attribute: .Edges                  ) } }
    public var m_frame:                 MortarAttribute { get { return MortarAttribute(view: self, attribute: .Frame                  ) } }
    public var m_center:                MortarAttribute { get { return MortarAttribute(view: self, attribute: .Center                 ) } }
    
    
}