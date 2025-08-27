//
//  MortarLayoutTests.swift
//  Copyright © 2025 Jason Fieldman.
//

@testable import Mortar
import XCTest

class MortarLayoutTests: XCTestCase {
    var testContainer: MortarView!

    override func setUp() {
        super.setUp()
        testContainer = MortarView(frame: .init(x: 200, y: 200, width: 1000, height: 1000))
    }

    override func tearDown() {
        super.tearDown()
    }

    func testEdgesConstraint() {
        var testView: MortarView!

        testContainer.configure {
            UILabel {
                $0.layout.edges == $0.parentLayout.edges
                testView = $0
            }
        }

        testContainer.layoutIfNeeded()
        XCTAssertEqual(testView.frame, CGRect(x: 0, y: 0, width: 1000, height: 1000))
    }
}
