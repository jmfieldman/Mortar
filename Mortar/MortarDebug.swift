//
//  MortarDebug.swift
//  Copyright © 2016 Jason Fieldman.
//

import CombineEx

public enum MortarDebug {
    static let errorSubject = MutableProperty<String?>(nil)
    public static let errorProperty = Property(errorSubject)
}
