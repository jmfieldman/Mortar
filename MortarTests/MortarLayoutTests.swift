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

    func testTopConstraint() {
        var testView: MortarView!

        testContainer.configure {
            UILabel {
                $0.layout.top == $0.parentLayout.top + 50
                $0.layout.bottom == $0.parentLayout.bottom
                testView = $0
            }
        }

        testContainer.layoutIfNeeded()
        XCTAssertEqual(testView.frame.origin.y, 50)
        XCTAssertEqual(testView.frame.size.height, 950)
    }

    func testBottomConstraint() {
        var testView: MortarView!

        testContainer.configure {
            UILabel {
                $0.layout.height == 100
                $0.layout.bottom == $0.parentLayout.bottom
                testView = $0
            }
        }

        testContainer.layoutIfNeeded()
        XCTAssertEqual(testView.frame.height, 100)
        XCTAssertEqual(testView.frame.origin.y, 900)
    }

    func testLeadingConstraint() {
        var testView: MortarView!

        testContainer.configure {
            UILabel {
                $0.layout.leading == $0.parentLayout.leading
                testView = $0
            }
        }

        testContainer.layoutIfNeeded()
        XCTAssertEqual(testView.frame.origin.x, 0)
    }

    func testTrailingConstraint() {
        var testView: MortarView!

        testContainer.configure {
            UILabel {
                $0.layout.leading == $0.parentLayout.leading
                $0.layout.trailing == $0.parentLayout.trailing
                testView = $0
            }
        }

        testContainer.layoutIfNeeded()
        XCTAssertEqual(testView.frame.origin.x, 1000 - testView.frame.width)
        XCTAssertEqual(testView.frame.size.width, 1000)
    }

    func testCenterXConstraint() {
        var testView: MortarView!

        testContainer.configure {
            UILabel {
                $0.layout.centerX == $0.parentLayout.centerX
                $0.layout.width == 500
                testView = $0
            }
        }

        testContainer.layoutIfNeeded()
        XCTAssertEqual(testView.center.x, 500)
        XCTAssertEqual(testView.frame.origin.x, 250)
        XCTAssertEqual(testView.bounds.size.width, 500)
    }

    func testCenterYConstraint() {
        var testView: MortarView!

        testContainer.configure {
            UILabel {
                $0.layout.centerY == $0.parentLayout.centerY
                $0.layout.height == 500
                testView = $0
            }
        }

        testContainer.layoutIfNeeded()
        XCTAssertEqual(testView.center.y, 500)
        XCTAssertEqual(testView.frame.origin.y, 250)
        XCTAssertEqual(testView.bounds.size.height, 500)
    }

    func testWidthConstraint() {
        var testView: MortarView!

        testContainer.configure {
            UILabel {
                $0.layout.width == 200
                testView = $0
            }
        }

        testContainer.layoutIfNeeded()
        XCTAssertEqual(testView.frame.width, 200)
    }

    func testHeightConstraint() {
        var testView: MortarView!

        testContainer.configure {
            UILabel {
                $0.layout.height == 300
                testView = $0
            }
        }

        testContainer.layoutIfNeeded()
        XCTAssertEqual(testView.frame.height, 300)
    }
}
