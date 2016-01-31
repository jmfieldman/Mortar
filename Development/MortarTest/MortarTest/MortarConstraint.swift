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
    internal init(targetMortar: MortarAttribute, sourceMortar: MortarAttribute, relation: NSLayoutRelation) {
        
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
            
            nsConstraints.append(NSLayoutConstraint(item: targetView,
                                               attribute: tLayoutAttribute,
                                               relatedBy: relation,
                                                  toItem: sourceView,
                                               attribute: sLayoutAttribute,
                                              multiplier: sourceMortar.multiplier,
                                                constant: sourceMortar.constant))
            
        }
        
        for constraint in nsConstraints {
            constraint.active = true
        }
    }
    
    /**
     Create a constraint relationship between a UIView and a Mortar Attribute.  Implicitly uses the
     same attribute for the corresponding UIView
     
     - parameter targetView:   Left-side view
     - parameter sourceMortar: Right-side attribute
     - parameter relation:     Equal, Greater, Less
     
     - returns: The constraint that is created
     */
    internal convenience init(targetView: UIView, sourceMortar: MortarAttribute, relation: NSLayoutRelation) {
        self.init(targetMortar: MortarAttribute(view: targetView),
                  sourceMortar: sourceMortar,
                      relation: relation)
    }
    
    /**
     Create a constraint relationship between a UIView and a Mortar Attribute.  Implicitly uses the
     same attribute for the corresponding UIView
     
     - parameter targetView:   Left-side attribute
     - parameter sourceMortar: Right-side view
     - parameter relation:     Equal, Greater, Less
     
     - returns: The constraint that is created
     */
    internal convenience init(targetMortar: MortarAttribute, sourceView: UIView, relation: NSLayoutRelation) {
        self.init(targetMortar: targetMortar,
                  sourceMortar: MortarAttribute(view: sourceView),
                      relation: relation)
    }

    /**
     Create a constraint relationship between a UIView and a UIView.  Implicitly uses the
     .Edges attribute for the constraint
     
     - parameter targetView:   Left-side view
     - parameter sourceMortar: Right-side view
     - parameter relation:     Equal, Greater, Less
     
     - returns: The constraint that is created
     */
    internal convenience init(targetView: UIView, sourceView: UIView, relation: NSLayoutRelation) {
        self.init(targetMortar: MortarAttribute(view: targetView),
                  sourceMortar: MortarAttribute(view: sourceView),
                      relation: relation)
        
    }
    
}
