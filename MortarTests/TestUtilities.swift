//
//  TestUtilities.swift
//  Copyright © 2016 Jason Fieldman.
//

@testable import Mortar
import XCTest

#if os(iOS) || os(tvOS)
typealias TestLabel = UILabel
#else
typealias TestLabel = NSTextView
extension NSTextView {
    var text: String? {
        get { "" }
        set { _ = newValue }
    }
}

extension NSView {
    func layoutIfNeeded() {
        layoutSubtreeIfNeeded()
    }

    var backgroundColor: NSColor {
        get { .red }
        set { _ = newValue }
    }
}
#endif
