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



public class MortarConstraint {
    
    /** constraints assigned for Mortar elements of type .LayoutConstraint */
    public internal(set) var layoutConstraints: [NSLayoutConstraint] = []
    
    
    /**
     This is the main glue initializer that binds two mortar elements into one.
     
     - parameter targetMortar: The left-hand side mortar; typically representing the
                               element whose attribute we are constraining
     - parameter sourceMortar: The right-hand side mortar; typically the value we are
                               constraining the target to.
     
     - returns: A mortar representing this layout constraint
     */
    internal convenience init(target: MortarAttributable, source: MortarAttributable, relation: NSLayoutRelation) {
        
        self.init()
        
        let targetMortar = target.m_intoAttribute()
        let sourceMortar = source.m_intoAttribute()
        
        /* The target view must be explicitly declared */
        guard let targetView = targetMortar.item as? MortarView else {
            NSException(name: NSExceptionName(rawValue: "Target Attribute must have a defined view"),
                      reason: "Target Attribute must have a defined view",
                    userInfo: nil).raise()
            return
        }
        
        /* The source view will default to the target superview to allow constants
           to be expressed by themselves (e.g. view1.m_top |=| 100) */
        let sourceItem = (sourceMortar.item == nil) ? targetView.superview : sourceMortar.item
        
        /* Attributes will inherit implicitly from the opposite side.
           If neither is declared, it will try to match edges */
        let targetAttribute = (targetMortar.attribute ?? sourceMortar.attribute) ?? .edges
        let sourceAttribute = (sourceMortar.attribute ?? targetMortar.attribute) ?? .edges
        
        /* Flag if we need baseline constant mod for things like view1.m_width |=| 40 */
        let needsImplicitBaseline = (targetMortar.attribute != nil) && (sourceMortar.attribute == nil) && (sourceMortar.item == nil)
        
        let targetComponents = targetAttribute.componentAttributes()
        let sourceComponents = sourceAttribute.componentAttributes()
        
        if (targetComponents.count != sourceComponents.count) {
            NSException(name: NSExceptionName(rawValue: "Attribute size mismatch"),
                      reason: "Binding two attributes of different size [left: \(targetAttribute) -> \(targetComponents.count), right: \(sourceAttribute) -> \(sourceComponents.count)]",
                    userInfo: nil).raise()
        }

        targetView.translatesAutoresizingMaskIntoConstraints = false
        
        for i in 0 ..< targetComponents.count {
            guard let tLayoutAttribute = targetComponents[i].nsLayoutAttribute() else {
                NSException(name: NSExceptionName(rawValue: "Component Attribute does not have corresponding NSLayoutAttribute"),
                          reason: "Component Attribute does not have corresponding NSLayoutAttribute: \(targetComponents[i])",
                        userInfo: nil).raise()
                continue
            }
            
            guard let sLayoutAttribute = sourceComponents[i].nsLayoutAttribute() else {
                NSException(name: NSExceptionName(rawValue: "Component Attribute does not have corresponding NSLayoutAttribute"),
                          reason: "Component Attribute does not have corresponding NSLayoutAttribute: \(sourceComponents[i])",
                        userInfo: nil).raise()
                continue
            }
            
            let constraint = NSLayoutConstraint(item: targetView,
                                           attribute: tLayoutAttribute,
                                           relatedBy: relation,
                                              toItem: (needsImplicitBaseline ? ( (targetComponents[i].implicitSuperviewBaseline() == .notAnAttribute) ? nil : targetView.superview ) : sourceItem),
                                           attribute: (needsImplicitBaseline ? targetComponents[i].implicitSuperviewBaseline() : sLayoutAttribute),
                                          multiplier: sourceMortar.multiplier[i],
                                            constant: sourceMortar.constant[i])
            
            constraint.priority = (sourceMortar.priority ?? targetMortar.priority) ?? MortarDefault.priority.current()
            constraint.isActive = true
            layoutConstraints.append(constraint)
        }        
    }
        
    
    internal convenience init(target: MortarAttribute, source: MortarTuple, relation: NSLayoutRelation) {
        
        self.init()
        
        /* The target view must be explicitly declared */
        guard let targetView = target.item as? MortarView else {
            NSException(name: NSExceptionName(rawValue: "Target Attribute must have a defined view"),
                      reason: "Target Attribute must have a defined view",
                    userInfo: nil).raise()
            return
        }
        
        /* For tuples, the target attribute must be explicitly declared */
        guard let targetAttribute = target.attribute else {
            NSException(name: NSExceptionName(rawValue: "Target Attribute must be defined"),
                      reason: "Target Attribute must be defined (cannot assign tuple to view without declaring attribute)",
                    userInfo: nil).raise()
            return
        }
        
        let targetComponents = targetAttribute.componentAttributes()
        
        if (targetComponents.count != source.0.count) {
            NSException(name: NSExceptionName(rawValue: "Invalid component count"),
                      reason: "Target Attribute expected component count \(targetComponents.count), source is \(source.0.count)",
                    userInfo: nil).raise()
            return
        }
        
        for i in 0 ..< targetComponents.count {
            let subAttribute  = MortarAttribute(item: targetView, attribute: targetComponents[i])
            
            if (subAttribute.priority == nil) {
                subAttribute.priority = source.1
            }
            
            let subConstraint = MortarConstraint(target: subAttribute, source: source.0[i], relation: relation)
            
            layoutConstraints += subConstraint.layoutConstraints
        }
    }
    
    internal convenience init(targetArray: [MortarAttribute], sourceArray: [MortarAttribute], crosslink: Bool, relation: NSLayoutRelation) {
        
        self.init()
        
        if crosslink {
            for target in targetArray {
                for source in sourceArray {
                    layoutConstraints += MortarConstraint(target: target, source: source, relation: relation).layoutConstraints
                }
            }
        } else {
            if (targetArray.count != sourceArray.count) {
                NSException(name: NSExceptionName(rawValue: "Constraining two arrays requires them to be the same length"),
                          reason: "Constraining two arrays requires them to be the same length.  target: \(targetArray.count), source: \(sourceArray.count)",
                        userInfo: nil).raise()
                return
            }
            
            for i in 0 ..< targetArray.count {
                layoutConstraints += MortarConstraint(target: targetArray[i], source: sourceArray[i], relation: relation).layoutConstraints
            }
        }
        
    }
    
    internal convenience init(targetArray: [MortarAttribute], sourceTuple: MortarTuple, relation: NSLayoutRelation) {
        self.init()
        
        for target in targetArray {
            layoutConstraints += MortarConstraint(target: target, source: sourceTuple, relation: relation).layoutConstraints
        }
    }
    
    internal convenience init(targetAny: Any, sourceAny: Any, relation: NSLayoutRelation) {
        if let target = (targetAny as? MortarAttribute) ?? (targetAny as? MortarAttributable)?.m_intoAttribute() {
            if let source = sourceAny as? MortarAttribute {
                self.init(target: target, source: source, relation: relation)
                return
            }
            
            if let source = sourceAny as? MortarTuple {
                self.init(target: target, source: source, relation: relation)
                return
            }
            
            if let source = sourceAny as? MortarTwople {
                self.init(target: target, source: MortarConvertTwople(source), relation: relation)
                return
            }
            
            if let source = sourceAny as? MortarFourple {
                self.init(target: target, source: MortarConvertFourple(source), relation: relation)
                return
            }
        }
        
        self.init()
        NSException(name: NSExceptionName(rawValue: "Invalid constraint pairing"),
                  reason: "Invalid constraint pair: target: \(targetAny), source: \(sourceAny)",
                userInfo: nil).raise()

    }
    
    internal convenience init(targetAnyArray: [Any], sourceAnyArray: [Any], crosslink: Bool, relation: NSLayoutRelation) {
        self.init()
        
        if crosslink {
            for target in targetAnyArray {
                for source in sourceAnyArray {
                    layoutConstraints += MortarConstraint(targetAny: target, sourceAny: source, relation: relation).layoutConstraints
                }
            }
        } else {
            if (targetAnyArray.count != sourceAnyArray.count) {
                NSException(name: NSExceptionName(rawValue: "Constraining two arrays requires them to be the same length"),
                          reason: "Constraining two arrays requires them to be the same length.  target: \(targetAnyArray.count), source: \(sourceAnyArray.count)",
                        userInfo: nil).raise()
                return
            }
            
            for i in 0 ..< targetAnyArray.count {
                layoutConstraints += MortarConstraint(targetAny: targetAnyArray[i], sourceAny: sourceAnyArray[i], relation: relation).layoutConstraints
            }
        }
    }
    
    @discardableResult
    public func activate() -> MortarConstraint {
        NSLayoutConstraint.activate(self.layoutConstraints)
        return self
    }
    
    @discardableResult
    public func deactivate() -> MortarConstraint {
        NSLayoutConstraint.deactivate(self.layoutConstraints)
        return self
    }
    
    @discardableResult
    public func replace(with newConstraint: MortarConstraint) -> MortarConstraint {
        self.deactivate()
        newConstraint.activate()
        return newConstraint
    }
    
    @discardableResult
    public func changePriority(to newPriority: MortarAliasLayoutPriority) -> MortarConstraint {
        for constraint in layoutConstraints {
            constraint.priority = newPriority
        }
        return self
    }
    
    @discardableResult
    public func changePriority(to newPriority: MortarLayoutPriority) -> MortarConstraint {
        for constraint in layoutConstraints {
            constraint.priority = newPriority.layoutPriority()
        }
        return self
    }
}
