//
//  MortarError.swift
//  Copyright © 2025 Jason Fieldman.
//

import CombineEx

public enum MortarError {
    static let errorSubject = MutableProperty<String?>(nil)
    static let installBag = NSObject()

    static func emit(_ message: String) {
        errorSubject.value = message
    }

    /// This publisher is exposed to the public and will emit Mortar errors.
    /// Any emission on this property is considered fatal and should trigger
    /// some kind of hard error in debug mode. In production, behavior of the
    /// Mortar APIs after an error is emitted is undefined.
    public static let errorProperty = Property(errorSubject)

    /// This helper allows you to install a block-based listener to Mortar errors
    /// without requiring any explicit publisher-based syntax. The hook lasts for
    /// the lifetime of the process.
    public static func install(hook: @escaping (String) -> Void) {
        errorSubject
            .compactMap(\.self)
            .sink(
                duringLifetimeOf: installBag,
                receiveValue: hook
            )
    }
}
