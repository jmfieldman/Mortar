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
//  THE SOFTWARE.s

#if os(iOS) || os(tvOS)
import UIKit
#else
import AppKit
#endif

internal let kMortarConstArrayLen = 4

public class MortarAttribute {
    
    /** Affected item for this mortar element */
    internal var item: AnyObject?
    
    /** attribute is assigned for Mortar elements of type .ViewAttribute */
    internal var attribute: MortarLayoutAttribute?
    
    /** The multiplier to apply to this attribute */
    internal var multiplier: Array<CGFloat> = Array<CGFloat>(repeating: 1.0, count: kMortarConstArrayLen)
    
    /** The offset constant to apply to this attribute */
    internal var constant: Array<CGFloat> = Array<CGFloat>(repeating: 0.0, count: kMortarConstArrayLen)
    
    /** What is the marked priority of this attribute as a source */
    internal var priority: MortarAliasLayoutPriority?

    
    /**
     Initialize a Mortar object to represent the layout attribute of a particular item.
     
     - parameter item:      The view to represent
     - parameter attribute: The layout attribute
     
     - returns: A Mortar object representing the layout property of this item
     */
    internal init(item: AnyObject?, attribute: MortarLayoutAttribute?) {
        self.item      = item
        self.attribute = attribute
    }
    
    /**
     Create a Mortar Attribute that represents an attribute-less item
     
     - parameter item: The item to create an attribute for
     
     - returns: The new Mortar Attribute
     */
    internal convenience init(item: AnyObject) {
        self.init(item: item, attribute: nil)
    }
    
    /**
     Create a Mortar Attribute that represents a constant metric
     
     - parameter constant: The value of the constant
     
     - returns: The new Mortar Attribute
     */
    internal convenience init(constant: MortarCGFloatable) {
        self.init(item: nil, attribute: nil)
        self.constant = Array<CGFloat>(repeating: constant.m_cgfloatValue(), count: kMortarConstArrayLen)
    }
    
    
}
