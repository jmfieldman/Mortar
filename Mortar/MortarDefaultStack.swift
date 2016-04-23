//
//  MortarDefaultStack.swift
//  Mortar
//
//  Created by Jason Fieldman on 4/23/16.
//  Copyright © 2016 Jason Fieldman. All rights reserved.
//

import Foundation


/* -- Defaults Stack -- */

internal var defaultPriorityStack: [UILayoutPriority] = []


/**
 The available defaults stacks.
 
 - Priority: The default priority stack.
 */
public enum MortarDefault {
    case Priority
    
    /**
     For .Priority:
     
     Push a new default layout priority onto the preferences stack.  Any constraint
     created will be given a priority that matches the top value on the stack.
     Default priorities can always be explicitly overridden.
     
     This function can only be called on the main thread, and must have a matching
     popDefaultPriority called before the main event loop is re-entered.
     
     - parameter value: The new default priority.
     */
    public func push(value: UILayoutPriority) {
        if !NSThread.currentThread().isMainThread {
            NSException(name: "InvalidPushState", reason: "Can only push state on main thread", userInfo: nil).raise()
        }
        
        switch self {
        case .Priority:
            dispatch_async(dispatch_get_main_queue()) {
                if defaultPriorityStack.count != 0 {
                    NSException(name: "InvalidStackState", reason: "You have unbalanced push/pop calls.", userInfo: nil).raise()
                }
            }
            
            defaultPriorityStack.append(value)
        }
    }
    
    /**
     For .Priority:
     
     Push a new default layout priority onto the preferences stack.  Any constraint
     created will be given a priority that matches the top value on the stack.
     Default priorities can always be explicitly overridden.
     
     This function can only be called on the main thread, and must have a matching
     popDefaultPriority called before the main event loop is re-entered.
     
     - parameter value: The new default priority.
     */
    public func push(value: MortarLayoutPriority) {
        push(value.layoutPriority())
    }
    
    /**
     For .Priority:
     
     Pops the top from the defaultPriority stack.  This must be called once for
     each corresponding push before the main event loop is re-entered.
     */
    public func pop() {
        if !NSThread.currentThread().isMainThread {
            NSException(name: "InvalidPopState", reason: "Can only pop state on main thread", userInfo: nil).raise()
        }
        
        switch self {
        case .Priority:
            if defaultPriorityStack.count < 1 {
                NSException(name: "InvalidPopState", reason: "There is nothing on the defaults stack to pop", userInfo: nil).raise()
            }
            
            defaultPriorityStack.removeLast()
        }
    }
    
    internal func current() -> UILayoutPriority {
        guard defaultPriorityStack.count > 0 else {
            return MortarAliasLayoutPriorityDefaultNormal
        }
        
        return defaultPriorityStack.last!
    }
}

