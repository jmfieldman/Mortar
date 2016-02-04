//
//  MortarConstraint.swift
//  MortarTest
//
//  Created by Jason Fieldman on 1/30/16.
//  Copyright © 2016 Jason Fieldman. All rights reserved.
//

import Foundation
import UIKit


public class MortarConstraint {
    
    /** constraints assigned for Mortar elements of type .LayoutConstraint */
    internal var nsConstraints: [NSLayoutConstraint] = []
    
    
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
        guard let targetView = targetMortar.view else {
            NSException(name: "Target Attribute must have a defined view",
                      reason: "Target Attribute must have a defined view",
                    userInfo: nil).raise()
            return
        }
        
        /* The source view will default to the target superview to allow constants
           to be expressed by themselves (e.g. view1.m_top |=| 100) */
        let sourceView = sourceMortar.view ?? targetView.superview
        
        /* Attributes will inherit implicitly from the opposite side.
           If neither is declared, it will try to match edges */
        let targetAttribute = (targetMortar.attribute ?? sourceMortar.attribute) ?? .Edges
        let sourceAttribute = (sourceMortar.attribute ?? targetMortar.attribute) ?? .Edges
        
        /* Flag if we need baseline constant mod for things like view1.m_width |=| 40 */
        let needsImplicitBaseline = (targetMortar.attribute != nil) && (sourceMortar.attribute == nil) && (sourceMortar.view == nil)
        
        let targetComponents = targetAttribute.componentAttributes()
        let sourceComponents = sourceAttribute.componentAttributes()
        
        if (targetComponents.count != sourceComponents.count) {
            NSException(name: "Attribute size mismatch",
                      reason: "Binding two attributes of different size [left: \(targetAttribute) -> \(targetComponents.count), right: \(sourceAttribute) -> \(sourceComponents.count)]",
                    userInfo: nil).raise()
        }

        targetView.translatesAutoresizingMaskIntoConstraints = false
        
        for i in 0 ..< targetComponents.count {
            guard let tLayoutAttribute = targetComponents[i].nsLayoutAttribute() else {
                NSException(name: "Component Attribute does not have corresponding NSLayoutAttribute",
                          reason: "Component Attribute does not have corresponding NSLayoutAttribute: \(targetComponents[i])",
                        userInfo: nil).raise()
                continue
            }
            
            guard let sLayoutAttribute = sourceComponents[i].nsLayoutAttribute() else {
                NSException(name: "Component Attribute does not have corresponding NSLayoutAttribute",
                          reason: "Component Attribute does not have corresponding NSLayoutAttribute: \(sourceComponents[i])",
                        userInfo: nil).raise()
                continue
            }
            
            let constraint = NSLayoutConstraint(item: targetView,
                                           attribute: tLayoutAttribute,
                                           relatedBy: relation,
                                              toItem: (needsImplicitBaseline ? ( (targetComponents[i].implicitSuperviewBaseline() == .NotAnAttribute) ? nil : targetView.superview ) : sourceView),
                                           attribute: (needsImplicitBaseline ? targetComponents[i].implicitSuperviewBaseline() : sLayoutAttribute),
                                          multiplier: sourceMortar.multiplier,
                                            constant: sourceMortar.constant)
            
            constraint.priority = (sourceMortar.priority ?? targetMortar.priority) ?? UILayoutPriorityDefault
            constraint.active   = true
            nsConstraints.append(constraint)
        }        
    }
        
    
    internal convenience init(target: MortarAttribute, source: MortarTuple, relation: NSLayoutRelation) {
        
        self.init()
        
        /* The target view must be explicitly declared */
        guard let targetView = target.view else {
            NSException(name: "Target Attribute must have a defined view",
                      reason: "Target Attribute must have a defined view",
                    userInfo: nil).raise()
            return
        }
        
        /* For tuples, the target attribute must be explicitly declared */
        guard let targetAttribute = target.attribute else {
            NSException(name: "Target Attribute must be defined",
                      reason: "Target Attribute must be defined (cannot assign to UIView with declaring attribute)",
                    userInfo: nil).raise()
            return
        }
        
        let targetComponents = targetAttribute.componentAttributes()
        
        if (targetComponents.count != source.0.count) {
            NSException(name: "Invalid component count",
                      reason: "Target Attribute expected component count \(targetComponents.count), source is \(source.0.count)",
                    userInfo: nil).raise()
            return
        }
        
        for i in 0 ..< targetComponents.count {
            let subAttribute  = MortarAttribute(view: targetView, attribute: targetComponents[i])
            
            if (subAttribute.priority == nil) {
                subAttribute.priority = source.1
            }
            
            let subConstraint = MortarConstraint(target: subAttribute, source: source.0[i], relation: relation)
            
            nsConstraints += subConstraint.nsConstraints
        }
    }
    
    internal convenience init(targetArray: [MortarAttribute], sourceArray: [MortarAttribute], crosslink: Bool, relation: NSLayoutRelation) {
        
        self.init()
        
        if crosslink {
            for target in targetArray {
                for source in sourceArray {
                    nsConstraints += MortarConstraint(target: target, source: source, relation: relation).nsConstraints
                }
            }
        } else {
            if (targetArray.count != sourceArray.count) {
                NSException(name: "Constraining two arrays requires them to be the same length",
                          reason: "Constraining two arrays requires them to be the same length.  target: \(targetArray.count), source: \(sourceArray.count)",
                        userInfo: nil).raise()
                return
            }
            
            for i in 0 ..< targetArray.count {
                nsConstraints += MortarConstraint(target: targetArray[i], source: sourceArray[i], relation: relation).nsConstraints
            }
        }
        
    }
}
