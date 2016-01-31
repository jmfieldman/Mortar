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
        let targetComponents = targetMortar.attribute.componentAttributes()
        let sourceComponents = sourceMortar.attribute.componentAttributes()
        
        if (targetComponents.count != sourceComponents.count) {
            NSException(name: "Attribute size mismatch",
                      reason: "Binding two attributes of different size [left: \(targetComponents.count), right: \(sourceComponents.count)]",
                    userInfo: nil).raise()
        }

        targetMortar.view.translatesAutoresizingMaskIntoConstraints = false
        
        for i in 0 ..< targetComponents.count {
            guard let tAttribute = targetComponents[i].nsLayoutAttribute() else {
                NSException(name: "Component Attribute does not have corresponding NSLayoutAttribute",
                          reason: "Component Attribute does not have corresponding NSLayoutAttribute: \(targetComponents[i])",
                        userInfo: nil).raise()
                continue
            }
            
            guard let sAttribute = sourceComponents[i].nsLayoutAttribute() else {
                NSException(name: "Component Attribute does not have corresponding NSLayoutAttribute",
                          reason: "Component Attribute does not have corresponding NSLayoutAttribute: \(sourceComponents[i])",
                        userInfo: nil).raise()
                continue
            }
            
            nsConstraints.append(NSLayoutConstraint(item: targetMortar.view,
                                               attribute: tAttribute,
                                               relatedBy: relation,
                                                  toItem: sourceMortar.view,
                                               attribute: sAttribute,
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
        self.init(targetMortar: MortarAttribute(view: targetView, attribute: sourceMortar.attribute),
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
                  sourceMortar: MortarAttribute(view: sourceView, attribute: targetMortar.attribute),
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
        self.init(targetMortar: MortarAttribute(view: targetView, attribute: .Edges),
                  sourceMortar: MortarAttribute(view: sourceView, attribute: .Edges),
                      relation: relation)
        
    }
    
}
