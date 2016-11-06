//
//  MortarDefaultStack.swift
//  Mortar
//
//  Created by Jason Fieldman on 4/23/16.
//  Copyright © 2016 Jason Fieldman. All rights reserved.
//

import Foundation


/* -- Defaults Stack -- */

internal var defaultPriorityStack: [MortarAliasLayoutPriority] = []
internal var defaultPriorityBase:   MortarAliasLayoutPriority  = MortarAliasLayoutPriorityDefaultRequired

/**
 The available defaults stacks.
 
 - Priority: The default priority stack.
 */
public enum MortarDefault {
    case priority
    
    
    /**
     Updates the new base value for this default (the value used when the stack is empty)
     
     - parameter newValue: The new value for the default.
     */
    public func set(base newValue: MortarAliasLayoutPriority) {
        if !Thread.current.isMainThread {
            NSException(name: NSExceptionName(rawValue: "InvalidSetState"), reason: "Can only set state on main thread", userInfo: nil).raise()
        }
        
        switch self {
        case .priority:
            defaultPriorityBase = newValue
        }
    }
    
    /**
     Updates the new base value for this default (the value used when the stack is empty)
     
     - parameter newValue: The new value for the default.
     */
    public func set(base newValue: MortarLayoutPriority) {
        if !Thread.current.isMainThread {
            NSException(name: NSExceptionName(rawValue: "InvalidSetState"), reason: "Can only set state on main thread", userInfo: nil).raise()
        }
        
        switch self {
        case .priority:
            defaultPriorityBase = newValue.layoutPriority()
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
    public func push(_ value: MortarAliasLayoutPriority) {
        if !Thread.current.isMainThread {
            NSException(name: NSExceptionName(rawValue: "InvalidPushState"), reason: "Can only push state on main thread", userInfo: nil).raise()
        }
        
        switch self {
        case .priority:
            DispatchQueue.main.async {
                if defaultPriorityStack.count != 0 {
                    NSException(name: NSExceptionName(rawValue: "InvalidStackState"), reason: "You have unbalanced push/pop calls.", userInfo: nil).raise()
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
    public func push(_ value: MortarLayoutPriority) {
        push(value.layoutPriority())
    }
    
    /**
     For .Priority:
     
     Pops the top from the defaultPriority stack.  This must be called once for
     each corresponding push before the main event loop is re-entered.
     */
    public func pop() {
        if !Thread.current.isMainThread {
            NSException(name: NSExceptionName(rawValue: "InvalidPopState"), reason: "Can only pop state on main thread", userInfo: nil).raise()
        }
        
        switch self {
        case .priority:
            if defaultPriorityStack.count < 1 {
                NSException(name: NSExceptionName(rawValue: "InvalidPopState"), reason: "There is nothing on the defaults stack to pop", userInfo: nil).raise()
            }
            
            defaultPriorityStack.removeLast()
        }
    }
    
    internal func current() -> MortarAliasLayoutPriority {
        switch self {
        case .priority:
            guard defaultPriorityStack.count > 0 else {
                return defaultPriorityBase
            }
        
            return defaultPriorityStack.last!
        }
    }
}

