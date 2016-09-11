//
//  LayoutConstraint+Mortar.swift
//  Mortar
//
//  Created by Brian Kenny on 2/25/16.
//  Copyright © 2016 Jason Fieldman. All rights reserved.
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


public extension NSLayoutConstraint {

    //! bakport of NSLayoutConstraint.active for iOS 7
    public var m_active: Bool {
        get {
            if #available(iOS 8.0, *) {
                return self.active
            } else {
                return (self.m_commonSuperview()?.constraints.indexOf(self) != nil)
            }
        }
        set(activate) {
            if #available(iOS 8.0, *) {
                self.active   = activate
            } else if let view = self.m_commonSuperview() {
                let addOrRemove = activate ? UIView.addConstraint : UIView.removeConstraint
                addOrRemove(view)(self)
            }
        }
    }

    //! bakport of NSLayoutConstraint.activateConstraints for iOS 7
    public class func m_activateConstraints(constraints: [NSLayoutConstraint]) {
        if #available(iOS 8.0, *) {
            NSLayoutConstraint.activateConstraints(constraints)
        } else {
            constraints.forEach { $0.m_active = true }
        }
    }

    //! bakport of NSLayoutConstraint.deactivateConstraints for iOS 7
    public class func m_deactivateConstraints(constraints: [NSLayoutConstraint]) {
        if #available(iOS 8.0, *) {
            NSLayoutConstraint.deactivateConstraints(constraints)
        } else {
            constraints.forEach { $0.m_active = false }
        }
    }

    //! The recomended view(generally common superview) to attach layout constraints to in iOS7
    private func m_commonSuperview ()->UIView? {
        if let view1 = self.firstItem as? UIView {
            if let view2 = self.secondItem as? UIView ,
                commonSuperview = view1.m_commonSuperview(view2) {
                    return commonSuperview
            } else {
                return view1
            }
        } else if let view = self.secondItem as? UIView {
            return view
        }
        return nil
    }

}