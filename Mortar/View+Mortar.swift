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
#else
import AppKit
#endif


public extension MortarView {
    
    // -------- Mortar Attributes --------
    
    public var m_left:                  MortarAttribute { get { return MortarAttribute(item: self, attribute: .left                   ) } }
    public var m_right:                 MortarAttribute { get { return MortarAttribute(item: self, attribute: .right                  ) } }
    public var m_top:                   MortarAttribute { get { return MortarAttribute(item: self, attribute: .top                    ) } }
    public var m_bottom:                MortarAttribute { get { return MortarAttribute(item: self, attribute: .bottom                 ) } }
    public var m_leading:               MortarAttribute { get { return MortarAttribute(item: self, attribute: .leading                ) } }
    public var m_trailing:              MortarAttribute { get { return MortarAttribute(item: self, attribute: .trailing               ) } }
    public var m_width:                 MortarAttribute { get { return MortarAttribute(item: self, attribute: .width                  ) } }
    public var m_height:                MortarAttribute { get { return MortarAttribute(item: self, attribute: .height                 ) } }
    public var m_centerX:               MortarAttribute { get { return MortarAttribute(item: self, attribute: .centerX                ) } }
    public var m_centerY:               MortarAttribute { get { return MortarAttribute(item: self, attribute: .centerY                ) } }
    public var m_baseline:              MortarAttribute { get { return MortarAttribute(item: self, attribute: .baseline               ) } }
    #if os(iOS) || os(tvOS)
    public var m_firstBaseline:         MortarAttribute { get { return MortarAttribute(item: self, attribute: .firstBaseline          ) } }
    public var m_leftMargin:            MortarAttribute { get { return MortarAttribute(item: self, attribute: .leftMargin             ) } }
    public var m_rightMargin:           MortarAttribute { get { return MortarAttribute(item: self, attribute: .rightMargin            ) } }
    public var m_topMargin:             MortarAttribute { get { return MortarAttribute(item: self, attribute: .topMargin              ) } }
    public var m_bottomMargin:          MortarAttribute { get { return MortarAttribute(item: self, attribute: .bottomMargin           ) } }
    public var m_leadingMargin:         MortarAttribute { get { return MortarAttribute(item: self, attribute: .leadingMargin          ) } }
    public var m_trailingMargin:        MortarAttribute { get { return MortarAttribute(item: self, attribute: .trailingMargin         ) } }
    public var m_centerXWithinMargin:   MortarAttribute { get { return MortarAttribute(item: self, attribute: .centerXWithinMargins   ) } }
    public var m_centerYWithinMargin:   MortarAttribute { get { return MortarAttribute(item: self, attribute: .centerYWithinMargins   ) } }
    #endif
    public var m_sides:                 MortarAttribute { get { return MortarAttribute(item: self, attribute: .sides                  ) } }
    public var m_caps:                  MortarAttribute { get { return MortarAttribute(item: self, attribute: .caps                   ) } }
    public var m_size:                  MortarAttribute { get { return MortarAttribute(item: self, attribute: .size                   ) } }
    public var m_cornerTL:              MortarAttribute { get { return MortarAttribute(item: self, attribute: .cornerTL               ) } }
    public var m_cornerTR:              MortarAttribute { get { return MortarAttribute(item: self, attribute: .cornerTR               ) } }
    public var m_cornerBL:              MortarAttribute { get { return MortarAttribute(item: self, attribute: .cornerBL               ) } }
    public var m_cornerBR:              MortarAttribute { get { return MortarAttribute(item: self, attribute: .cornerBR               ) } }
    public var m_edges:                 MortarAttribute { get { return MortarAttribute(item: self, attribute: .edges                  ) } }
    public var m_frame:                 MortarAttribute { get { return MortarAttribute(item: self, attribute: .frame                  ) } }
    public var m_center:                MortarAttribute { get { return MortarAttribute(item: self, attribute: .center                 ) } }
    
    // -------- Compression Resistance --------
    
    public var m_compResistH: MortarAliasLayoutPriority {
        set { self.setContentCompressionResistancePriority(newValue, for: .horizontal) }
        get { return self.contentCompressionResistancePriority(for: .horizontal) }
    }
    
    public var m_compResistV: MortarAliasLayoutPriority {
        set { self.setContentCompressionResistancePriority(newValue, for: .vertical) }
        get { return self.contentCompressionResistancePriority(for: .vertical) }
    }
    
    public var m_compResist: MortarAliasLayoutPriority {
        set {
            self.setContentCompressionResistancePriority(newValue, for: .horizontal)
            self.setContentCompressionResistancePriority(newValue, for: .vertical)
        }
        get {
            NSException(name: NSExceptionName(rawValue: "InvalidGetter"), reason: "You must get m_compressionH and m_compressionV independently", userInfo: nil).raise()
            return 0
        }
    }
    
    // -------- Content Hugging --------
    
    public var m_huggingH: MortarAliasLayoutPriority {
        set { self.setContentHuggingPriority(newValue, for: .horizontal) }
        get { return self.contentHuggingPriority(for: .horizontal) }
    }
    
    public var m_huggingV: MortarAliasLayoutPriority {
        set { self.setContentHuggingPriority(newValue, for: .vertical) }
        get { return self.contentHuggingPriority(for: .vertical) }
    }
    
    public var m_hugging: MortarAliasLayoutPriority {
        set {
            self.setContentHuggingPriority(newValue, for: .horizontal)
            self.setContentHuggingPriority(newValue, for: .vertical)
        }
        get {
            NSException(name: NSExceptionName(rawValue: "InvalidGetter"), reason: "You must get m_compressionH and m_compressionV independently", userInfo: nil).raise()
            return 0
        }
    }
    
}

#if os(iOS)
public extension UIViewController {
    public var m_topLayoutGuideTop:       MortarAttribute { return MortarAttribute(item: self.topLayoutGuide,    attribute: .top)    }
    public var m_topLayoutGuideBottom:    MortarAttribute { return MortarAttribute(item: self.topLayoutGuide,    attribute: .bottom) }
    public var m_bottomLayoutGuideTop:    MortarAttribute { return MortarAttribute(item: self.bottomLayoutGuide, attribute: .top)    }
    public var m_bottomLayoutGuideBottom: MortarAttribute { return MortarAttribute(item: self.bottomLayoutGuide, attribute: .bottom) }
}
#endif
