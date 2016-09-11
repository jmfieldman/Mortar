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


public typealias MortarGroup = [MortarConstraint]

public extension Array where Element: MortarConstraint {

    @discardableResult
    public func activate() -> MortarGroup {
        NSLayoutConstraint.activate(self.layoutConstraints)
        return self
    }
    
    @discardableResult
    public func deactivate() -> MortarGroup {
        NSLayoutConstraint.deactivate(self.layoutConstraints)
        return self
    }
    
    public var layoutConstraints: [NSLayoutConstraint] {
        var response: [NSLayoutConstraint] = []
        self.forEach {
            response += $0.layoutConstraints
        }
        return response
    }
    
    @discardableResult
    public func replace(with newConstraints: MortarGroup) -> MortarGroup {
        self.deactivate()
        newConstraints.activate()
        return newConstraints
    }
    
    @discardableResult
    public func changePriority(to newPriority: MortarAliasLayoutPriority) -> MortarGroup {
        for constraint in self {
            constraint.changePriority(to: newPriority)
        }
        return self
    }
    
    @discardableResult
    public func changePriority(to newPriority: MortarLayoutPriority) -> MortarGroup {
        for constraint in self {
            constraint.changePriority(to: newPriority)
        }
        return self
    }
}
