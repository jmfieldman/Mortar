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
    
    var m_left:                 MortarAttribute { get { return MortarAttribute(item: self, attribute: .left                   ) } }
    var m_right:                MortarAttribute { get { return MortarAttribute(item: self, attribute: .right                  ) } }
    var m_top:                  MortarAttribute { get { return MortarAttribute(item: self, attribute: .top                    ) } }
    var m_bottom:               MortarAttribute { get { return MortarAttribute(item: self, attribute: .bottom                 ) } }
    var m_leading:              MortarAttribute { get { return MortarAttribute(item: self, attribute: .leading                ) } }
    var m_trailing:             MortarAttribute { get { return MortarAttribute(item: self, attribute: .trailing               ) } }
    var m_width:                MortarAttribute { get { return MortarAttribute(item: self, attribute: .width                  ) } }
    var m_height:               MortarAttribute { get { return MortarAttribute(item: self, attribute: .height                 ) } }
    var m_centerX:              MortarAttribute { get { return MortarAttribute(item: self, attribute: .centerX                ) } }
    var m_centerY:              MortarAttribute { get { return MortarAttribute(item: self, attribute: .centerY                ) } }
    var m_baseline:             MortarAttribute { get { return MortarAttribute(item: self, attribute: .baseline               ) } }
    #if os(iOS) || os(tvOS)
    var m_firstBaseline:        MortarAttribute { get { return MortarAttribute(item: self, attribute: .firstBaseline          ) } }
    var m_leftMargin:           MortarAttribute { get { return MortarAttribute(item: self, attribute: .leftMargin             ) } }
    var m_rightMargin:          MortarAttribute { get { return MortarAttribute(item: self, attribute: .rightMargin            ) } }
    var m_topMargin:            MortarAttribute { get { return MortarAttribute(item: self, attribute: .topMargin              ) } }
    var m_bottomMargin:         MortarAttribute { get { return MortarAttribute(item: self, attribute: .bottomMargin           ) } }
    var m_leadingMargin:        MortarAttribute { get { return MortarAttribute(item: self, attribute: .leadingMargin          ) } }
    var m_trailingMargin:       MortarAttribute { get { return MortarAttribute(item: self, attribute: .trailingMargin         ) } }
    var m_centerXWithinMargin:  MortarAttribute { get { return MortarAttribute(item: self, attribute: .centerXWithinMargins   ) } }
    var m_centerYWithinMargin:  MortarAttribute { get { return MortarAttribute(item: self, attribute: .centerYWithinMargins   ) } }
    #endif
    var m_sides:                MortarAttribute { get { return MortarAttribute(item: self, attribute: .sides                  ) } }
    var m_caps:                 MortarAttribute { get { return MortarAttribute(item: self, attribute: .caps                   ) } }
    var m_size:                 MortarAttribute { get { return MortarAttribute(item: self, attribute: .size                   ) } }
    var m_cornerTL:             MortarAttribute { get { return MortarAttribute(item: self, attribute: .cornerTL               ) } }
    var m_cornerTR:             MortarAttribute { get { return MortarAttribute(item: self, attribute: .cornerTR               ) } }
    var m_cornerBL:             MortarAttribute { get { return MortarAttribute(item: self, attribute: .cornerBL               ) } }
    var m_cornerBR:             MortarAttribute { get { return MortarAttribute(item: self, attribute: .cornerBR               ) } }
    var m_edges:                MortarAttribute { get { return MortarAttribute(item: self, attribute: .edges                  ) } }
    var m_frame:                MortarAttribute { get { return MortarAttribute(item: self, attribute: .frame                  ) } }
    var m_center:               MortarAttribute { get { return MortarAttribute(item: self, attribute: .center                 ) } }
    
    // -------- Compression Resistance --------
    
    var m_compResistH: MortarAliasLayoutPriorityAble {
        set { self.setContentCompressionResistancePriority(newValue.m_intoPriority(), for: .horizontal) }
        get { return self.contentCompressionResistancePriority(for: .horizontal) }
    }
    
    var m_compResistV: MortarAliasLayoutPriorityAble {
        set { self.setContentCompressionResistancePriority(newValue.m_intoPriority(), for: .vertical) }
        get { return self.contentCompressionResistancePriority(for: .vertical) }
    }
    
    var m_compResist: MortarAliasLayoutPriorityAble {
        set {
            self.setContentCompressionResistancePriority(newValue.m_intoPriority(), for: .horizontal)
            self.setContentCompressionResistancePriority(newValue.m_intoPriority(), for: .vertical)
        }
        get {
            NSException(name: NSExceptionName(rawValue: "InvalidGetter"), reason: "You must get m_compressionH and m_compressionV independently", userInfo: nil).raise()
            return MortarAliasLayoutPriority(rawValue: 0)
        }
    }
    
    // -------- Content Hugging --------
    
    var m_huggingH: MortarAliasLayoutPriorityAble {
        set { self.setContentHuggingPriority(newValue.m_intoPriority(), for: .horizontal) }
        get { return self.contentHuggingPriority(for: .horizontal) }
    }
    
    var m_huggingV: MortarAliasLayoutPriorityAble {
        set { self.setContentHuggingPriority(newValue.m_intoPriority(), for: .vertical) }
        get { return self.contentHuggingPriority(for: .vertical) }
    }
    
    var m_hugging: MortarAliasLayoutPriorityAble {
        set {
            self.setContentHuggingPriority(newValue.m_intoPriority(), for: .horizontal)
            self.setContentHuggingPriority(newValue.m_intoPriority(), for: .vertical)
        }
        get {
            NSException(name: NSExceptionName(rawValue: "InvalidGetter"), reason: "You must get m_compressionH and m_compressionV independently", userInfo: nil).raise()
            return MortarAliasLayoutPriority(rawValue: 0)
        }
    }
    
}

#if os(iOS)
public extension UIViewController {
    var m_topLayoutGuideTop:        MortarAttribute { return MortarAttribute(item: self.topLayoutGuide,    attribute: .top)    }
    var m_topLayoutGuideBottom:     MortarAttribute { return MortarAttribute(item: self.topLayoutGuide,    attribute: .bottom) }
    var m_bottomLayoutGuideTop:     MortarAttribute { return MortarAttribute(item: self.bottomLayoutGuide, attribute: .top)    }
    var m_bottomLayoutGuideBottom:  MortarAttribute { return MortarAttribute(item: self.bottomLayoutGuide, attribute: .bottom) }
}
#endif

#if os(iOS) || os(tvOS)
public extension UILayoutGuide {

    // -------- Mortar Attributes --------

    var m_left:                 MortarAttribute { get { return MortarAttribute(item: self, attribute: .left                   ) } }
    var m_right:                MortarAttribute { get { return MortarAttribute(item: self, attribute: .right                  ) } }
    var m_top:                  MortarAttribute { get { return MortarAttribute(item: self, attribute: .top                    ) } }
    var m_bottom:               MortarAttribute { get { return MortarAttribute(item: self, attribute: .bottom                 ) } }
    var m_leading:              MortarAttribute { get { return MortarAttribute(item: self, attribute: .leading                ) } }
    var m_trailing:             MortarAttribute { get { return MortarAttribute(item: self, attribute: .trailing               ) } }
    var m_width:                MortarAttribute { get { return MortarAttribute(item: self, attribute: .width                  ) } }
    var m_height:               MortarAttribute { get { return MortarAttribute(item: self, attribute: .height                 ) } }
    var m_centerX:              MortarAttribute { get { return MortarAttribute(item: self, attribute: .centerX                ) } }
    var m_centerY:              MortarAttribute { get { return MortarAttribute(item: self, attribute: .centerY                ) } }
    var m_baseline:             MortarAttribute { get { return MortarAttribute(item: self, attribute: .baseline               ) } }
    #if os(iOS) || os(tvOS)
    var m_firstBaseline:        MortarAttribute { get { return MortarAttribute(item: self, attribute: .firstBaseline          ) } }
    var m_leftMargin:           MortarAttribute { get { return MortarAttribute(item: self, attribute: .leftMargin             ) } }
    var m_rightMargin:          MortarAttribute { get { return MortarAttribute(item: self, attribute: .rightMargin            ) } }
    var m_topMargin:            MortarAttribute { get { return MortarAttribute(item: self, attribute: .topMargin              ) } }
    var m_bottomMargin:         MortarAttribute { get { return MortarAttribute(item: self, attribute: .bottomMargin           ) } }
    var m_leadingMargin:        MortarAttribute { get { return MortarAttribute(item: self, attribute: .leadingMargin          ) } }
    var m_trailingMargin:       MortarAttribute { get { return MortarAttribute(item: self, attribute: .trailingMargin         ) } }
    var m_centerXWithinMargin:  MortarAttribute { get { return MortarAttribute(item: self, attribute: .centerXWithinMargins   ) } }
    var m_centerYWithinMargin:  MortarAttribute { get { return MortarAttribute(item: self, attribute: .centerYWithinMargins   ) } }
    #endif
    var m_sides:                MortarAttribute { get { return MortarAttribute(item: self, attribute: .sides                  ) } }
    var m_caps:                 MortarAttribute { get { return MortarAttribute(item: self, attribute: .caps                   ) } }
    var m_size:                 MortarAttribute { get { return MortarAttribute(item: self, attribute: .size                   ) } }
    var m_cornerTL:             MortarAttribute { get { return MortarAttribute(item: self, attribute: .cornerTL               ) } }
    var m_cornerTR:             MortarAttribute { get { return MortarAttribute(item: self, attribute: .cornerTR               ) } }
    var m_cornerBL:             MortarAttribute { get { return MortarAttribute(item: self, attribute: .cornerBL               ) } }
    var m_cornerBR:             MortarAttribute { get { return MortarAttribute(item: self, attribute: .cornerBR               ) } }
    var m_edges:                MortarAttribute { get { return MortarAttribute(item: self, attribute: .edges                  ) } }
    var m_frame:                MortarAttribute { get { return MortarAttribute(item: self, attribute: .frame                  ) } }
    var m_center:               MortarAttribute { get { return MortarAttribute(item: self, attribute: .center                 ) } }
}
#endif
