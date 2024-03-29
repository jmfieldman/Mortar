//
//  Mortar
//
//  Copyright (c) 2016-Present Jason Fieldman - https://github.com/jmfieldman/Mortar
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import XCTest
@testable import Mortar

#if os(iOS) || os(tvOS)
typealias TestLabel = UILabel
#else
typealias TestLabel = NSTextView
extension NSTextView {
  var text: String? {
    get { return "" }
    set { _ = newValue }
  }
}

extension NSView {
  func layoutIfNeeded() {
    layoutSubtreeIfNeeded()
  }
  
  var backgroundColor: NSColor {
    get { return .red }
    set { _ = newValue }
  }
}
#endif

class MortarTests: XCTestCase {
    
    static let CON_X: CGFloat = 100.0
    static let CON_Y: CGFloat = 50.0
    static let CON_W: CGFloat = 1000.0
    static let CON_H: CGFloat = 500.0
    
    let container = MortarView(frame: CGRect(x: CON_X, y: CON_Y, width: CON_W, height: CON_H))
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func compiling() {
        let z = MortarView()
        let x = MortarView()
        
        x |>> z
        x |> z
        x <! x
        x | z | x <! z
        x[==44] | x[==x] <! z
        z |>> z || x || x | z
        z ||>> z || x | z | x | 40 || 4 | z
        z ||> z[==x] | 30 | 4||x[~~z]
        [x, z, x, z, x][==44] ^! z
        z |>> x | x | x[~~2] | z | x
        z |>> x[==44] || x || z[==44]
        z.m_right |> 30 | x | 30 | z || 30 <|| z.m_left
        
    }
    
    func testBasicConstruction() {
        let v = MortarView()
        
        self.container |+| v
        
        v.m_edges |=| self.container
        
        XCTAssertEqual(self.container.constraints.count, 4, "Should have 4 constraints installed (ancestor)")
        XCTAssertEqual(v.constraints.count, 0, "Should have 0 constraints installed (constraints installed on ancestor)")
    }
    
    func testArrayConstruction() {
        let v = MortarView()
        
        self.container |+| v
        
        v |=| [self.container.m_caps, self.container.m_sides]
        
        XCTAssertEqual(self.container.constraints.count, 4, "Should have 4 constraints installed (ancestor)")
        XCTAssertEqual(v.constraints.count, 0, "Should have 0 constraints installed (constraints installed on ancestor)")
    }
    
    func testBasicMultipleAssignment() {
        let v1 = MortarView()
        let v2 = MortarView()
        let v3 = MortarView()
        
        self.container |+| [v1, v2, v3]
        
        [v1, v2, v3].m_height |=| self.container
        
        XCTAssertEqual(self.container.constraints.count, 3, "Should have 3 constraints installed (ancestor)")
        XCTAssertEqual(v1.constraints.count, 0, "Should have 0 constraints installed (constraints installed on ancestor)")
        XCTAssertEqual(v2.constraints.count, 0, "Should have 0 constraints installed (constraints installed on ancestor)")
        XCTAssertEqual(v3.constraints.count, 0, "Should have 0 constraints installed (constraints installed on ancestor)")
    }
    
    func testBasicMultipleAssignment2() {
        let v1 = MortarView()
        let v2 = MortarView()
        let v3 = MortarView()
        
        self.container |+| [v1, v2, v3]
        
        [v1.m_height, v2.m_height, v3.m_height] |=| self.container
        
        XCTAssertEqual(self.container.constraints.count, 3, "Should have 3 constraints installed (ancestor)")
        XCTAssertEqual(v1.constraints.count, 0, "Should have 0 constraints installed (constraints installed on ancestor)")
        XCTAssertEqual(v2.constraints.count, 0, "Should have 0 constraints installed (constraints installed on ancestor)")
        XCTAssertEqual(v3.constraints.count, 0, "Should have 0 constraints installed (constraints installed on ancestor)")
    }
    
    func testBasicMultipleAssignment3() {
        let v1 = MortarView()
        
        self.container |+| v1
        
        [v1.m_sides, v1.m_top, v1.m_height] |=| [self.container, self.container, 200]
        
        XCTAssertEqual(self.container.constraints.count, 3, "Should have 3 constraints installed (ancestor)")
        XCTAssertEqual(v1.constraints.count, 1, "Should have 1 constraint (fixed height)")
    }
    
    func testBasicActivatationToggle() {
        let v = MortarView()
        
        self.container |+| v
        
        let c = v.m_edges |=| self.container
        
        XCTAssertEqual(self.container.constraints.count, 4, "Should have 4 constraints installed (ancestor)")
        XCTAssertEqual(v.constraints.count, 0, "Should have 0 constraints installed (constraints installed on ancestor)")
        
        c.deactivate()
        
        XCTAssertEqual(self.container.constraints.count, 0, "Should have 0 constraints installed (deactivated)")
        XCTAssertEqual(v.constraints.count, 0, "Should have 0 constraints installed (constraints installed on ancestor)")
        
        c.activate()
        
        XCTAssertEqual(self.container.constraints.count, 4, "Should have 4 constraints installed (activated)")
        XCTAssertEqual(v.constraints.count, 0, "Should have 0 constraints installed (constraints installed on ancestor)")
    }
    
    func testDeactivatedConstraint() {
        let v = MortarView()
        
        self.container |+| v
        
        let c = v.m_edges |=| self.container ~~ .deactivated
        
        XCTAssertEqual(self.container.constraints.count, 0, "Should have 4 constraints installed (ancestor)")
        XCTAssertEqual(v.constraints.count, 0, "Should have 0 constraints installed (constraints installed on ancestor)")
        
        c ~~ .activated
        
        XCTAssertEqual(self.container.constraints.count, 4, "Should have 4 constraints installed (activated)")
        XCTAssertEqual(v.constraints.count, 0, "Should have 0 constraints installed (constraints installed on ancestor)")
    }
    
    func testDeactivatedGroupConstraint() {
        let v1 = MortarView()
        let v2 = MortarView()
        
        self.container |+| [v1, v2]
        
        let c = [
            v1.m_edges |=| self.container,
            v2.m_edges |=| self.container
        ] ~~ .deactivated
        
        XCTAssertEqual(self.container.constraints.count, 0, "Should have 8 constraints installed (ancestor)")
        XCTAssertEqual(v1.constraints.count, 0, "Should have 0 constraints installed (constraints installed on ancestor)")
        XCTAssertEqual(v2.constraints.count, 0, "Should have 0 constraints installed (constraints installed on ancestor)")
        
        c ~~ .activated
        
        XCTAssertEqual(self.container.constraints.count, 8, "Should have 8 constraints installed (activated)")
        XCTAssertEqual(v1.constraints.count, 0, "Should have 0 constraints installed (constraints installed on ancestor)")
        XCTAssertEqual(v2.constraints.count, 0, "Should have 0 constraints installed (constraints installed on ancestor)")
    }
    
    func testBasicGroup() {
        let v = MortarView()
        
        self.container |+| v
        
        let g = [
            v.m_sides |=| self.container,
            v.m_caps  |=| self.container,
        ]
        
        XCTAssertEqual(self.container.constraints.count, 4, "Should have 4 constraints installed (ancestor)")
        XCTAssertEqual(v.constraints.count, 0, "Should have 0 constraints installed (constraints installed on ancestor)")
        
        g.deactivate()
        
        XCTAssertEqual(self.container.constraints.count, 0, "Should have 0 constraints installed (deactivated)")
        XCTAssertEqual(v.constraints.count, 0, "Should have 0 constraints installed (constraints installed on ancestor)")
        
        g.activate()
        
        XCTAssertEqual(self.container.constraints.count, 4, "Should have 4 constraints installed (activated)")
        XCTAssertEqual(v.constraints.count, 0, "Should have 0 constraints installed (constraints installed on ancestor)")
        
        self.container.layoutIfNeeded()
        
        XCTAssertEqual(v.frame.origin.x, 0, "Frame mismatch")
        XCTAssertEqual(v.frame.origin.y, 0, "Frame mismatch")
        XCTAssertEqual(v.frame.size.width,  MortarTests.CON_W, "Frame mismatch")
        XCTAssertEqual(v.frame.size.height, MortarTests.CON_H, "Frame mismatch")
    }

    func testBasicFrame() {
        let v = MortarView()
        
        self.container |+| v
        
        v.m_edges |=| self.container
        
        self.container.layoutIfNeeded()
        
        XCTAssertEqual(v.frame.origin.x, 0, "Frame mismatch")
        XCTAssertEqual(v.frame.origin.y, 0, "Frame mismatch")
        XCTAssertEqual(v.frame.size.width,  MortarTests.CON_W, "Frame mismatch")
        XCTAssertEqual(v.frame.size.height, MortarTests.CON_H, "Frame mismatch")
    }

    #if os(iOS) || os(tvOS)
    func testUIEdgeInsets() {
        let v = MortarView()

        self.container |+| v

        v.m_edges |=| self.container.m_edges ~ UIEdgeInsets(top: 4, left: 8, bottom: 12, right: 16)

        self.container.layoutIfNeeded()

        XCTAssertEqual(v.frame.origin.x, 8, "Frame mismatch")
        XCTAssertEqual(v.frame.origin.y, 4, "Frame mismatch")
        XCTAssertEqual(v.frame.size.width,  MortarTests.CON_W - 24, "Frame mismatch")
        XCTAssertEqual(v.frame.size.height, MortarTests.CON_H - 16, "Frame mismatch")
    }
    #endif

    func testSizeInsets() {
        let v = MortarView()

        self.container |+| v

        v.m_center |=| self.container
        v.m_size |=| self.container.m_size ~ (10, 10)

        self.container.layoutIfNeeded()

        XCTAssertEqual(v.frame.size.width,  MortarTests.CON_W - 10, "Frame mismatch")
        XCTAssertEqual(v.frame.size.height, MortarTests.CON_H - 10, "Frame mismatch")
    }
    
    func testAddSubviews() {
        let v1 = MortarView()
        let v2 = MortarView()
        let v3 = MortarView()
        let v4 = MortarView()
        
        self.container |+| [
            v1,
            v2 |+| [
                v3,
                v4
            ]
        ]
        
        XCTAssertEqual(v1, self.container.subviews[0], "Hierarchy mismatch")
        XCTAssertEqual(v2, self.container.subviews[1], "Hierarchy mismatch")
        
        XCTAssertEqual(v1.superview, self.container, "Hierarchy mismatch")
        XCTAssertEqual(v2.superview, self.container, "Hierarchy mismatch")
        XCTAssertEqual(v3.superview, v2, "Hierarchy mismatch")
        XCTAssertEqual(v4.superview, v2, "Hierarchy mismatch")
        
    }

    #if os(iOS)
    func testAddArrangedSubviews() {
        let v1 = MortarView()
        let v2 = UIStackView()
        let v3 = MortarView()
        let v4 = MortarView()

        self.container |+| [
            v1,
            v2 |+| [
                v3,
                v4
            ]
        ]

        XCTAssertEqual(v1, self.container.subviews[0], "Hierarchy mismatch")
        XCTAssertEqual(v2, self.container.subviews[1], "Hierarchy mismatch")

        XCTAssertEqual(v1.superview, self.container, "Hierarchy mismatch")
        XCTAssertEqual(v2.superview, self.container, "Hierarchy mismatch")
        XCTAssertEqual(v3.superview, v2, "Hierarchy mismatch")
        XCTAssertEqual(v4.superview, v2, "Hierarchy mismatch")

        XCTAssertEqual(v2.arrangedSubviews.count, 2)
    }
    #endif
    
    func testAddReverseSubviews() {
        let v1 = MortarView()
        let v2 = MortarView()
        let v3 = MortarView()
        let v4 = MortarView()
        
        self.container |^| [
            v1,
            v2 |^| [
                v3,
                v4
            ]
        ]
        
        XCTAssertEqual(v1, self.container.subviews[1], "Hierarchy mismatch")
        XCTAssertEqual(v2, self.container.subviews[0], "Hierarchy mismatch")
        
        XCTAssertEqual(v1.superview, self.container, "Hierarchy mismatch")
        XCTAssertEqual(v2.superview, self.container, "Hierarchy mismatch")
        XCTAssertEqual(v3.superview, v2, "Hierarchy mismatch")
        XCTAssertEqual(v4.superview, v2, "Hierarchy mismatch")
        
    }
    
    func testBasicInset() {
        let v = MortarView()
        
        self.container |+| v
        
        v |=| self.container.m_edges ~ (10, 10, 10, 10)
        
        self.container.layoutIfNeeded()
        
        XCTAssertEqual(v.frame.origin.x, 10, "Frame mismatch")
        XCTAssertEqual(v.frame.origin.y, 10, "Frame mismatch")
        XCTAssertEqual(v.frame.size.width,  MortarTests.CON_W - 20, "Frame mismatch")
        XCTAssertEqual(v.frame.size.height, MortarTests.CON_H - 20, "Frame mismatch")
    }
    
    func testBasicMult() {
        let v = MortarView()
        
        self.container |+| v
        
        v |=| self.container.m_height * 2
        
        self.container.layoutIfNeeded()
        
        XCTAssertEqual(v.frame.size.height, MortarTests.CON_H * 2, "Frame mismatch")
    }
    
    func testBasicConst() {
        let v = MortarView()
        
        self.container |+| v
        
        v |=| self.container.m_height + 5
        
        self.container.layoutIfNeeded()
        
        XCTAssertEqual(v.frame.size.height, MortarTests.CON_H + 5, "Frame mismatch")
    }
    
    func testBasicCombo() {
        let v = MortarView()
        
        self.container |+| v
        
        v |=| self.container.m_height * 2 + 5
        
        self.container.layoutIfNeeded()
        
        XCTAssertEqual(v.frame.size.height, MortarTests.CON_H * 2 + 5, "Frame mismatch")
    }
    
    func testBasicTupleCombo() {
        let v = MortarView()
        
        self.container |+| v
        
        v |=| self.container.m_size * 2 + 5
        
        self.container.layoutIfNeeded()
        
        XCTAssertEqual(v.frame.size.width,  MortarTests.CON_W * 2 + 5, "Frame mismatch")
        XCTAssertEqual(v.frame.size.height, MortarTests.CON_H * 2 + 5, "Frame mismatch")
    }
    
    func testBasicArraySizeAttachment() {
        let v1 = MortarView()
        let v2 = MortarView()
        
        let v3 = MortarView()
        let v4 = MortarView()
        
        self.container |+| [v1, v2, v3, v4]
    
        [v1, v2].m_size |=| (7, 11) ! .required
        [v3, v4]        |=| v1 ! .required
        
        self.container.layoutIfNeeded()
        
        XCTAssertEqual(v1.frame.size.width,  7,  "Frame mismatch")
        XCTAssertEqual(v2.frame.size.height, 11, "Frame mismatch")
        XCTAssertEqual(v3.frame.size.width,  7,  "Frame mismatch")
        XCTAssertEqual(v4.frame.size.height, 11, "Frame mismatch")
    }
    
    func testBasicPriority() {
        let v0 = MortarView()
        let v1 = MortarView()
        let v2 = MortarView()
        let v3 = MortarView()
        let v4 = MortarView()
        let v5 = MortarView()
        
        self.container |+| [v0, v1, v2, v3, v4, v5]
        
        v0 |=| self.container.m_height
        v1 |=| self.container.m_height ! .low
        v2 |=| self.container.m_height ! .medium
        v3 |=| self.container.m_height ! .high
        v4 |=| self.container.m_height ! .required
        v5 |=| self.container.m_height ! 300
        
        XCTAssertEqual(self.container.constraints[0].priority.rawValue, MortarAliasLayoutPriorityDefaultRequired.rawValue,    "Priority mismatch")
        XCTAssertEqual(self.container.constraints[1].priority.rawValue, MortarAliasLayoutPriorityDefaultLow.rawValue,         "Priority mismatch")
        XCTAssertEqual(self.container.constraints[2].priority.rawValue, MortarAliasLayoutPriorityDefaultMedium.rawValue,      "Priority mismatch")
        XCTAssertEqual(self.container.constraints[3].priority.rawValue, MortarAliasLayoutPriorityDefaultHigh.rawValue,        "Priority mismatch")
        XCTAssertEqual(self.container.constraints[4].priority.rawValue, MortarAliasLayoutPriorityDefaultRequired.rawValue,    "Priority mismatch")
        XCTAssertEqual(self.container.constraints[5].priority.rawValue, 300,                                                  "Priority mismatch")
    }
    
    func testBasicPriorityBase() {
        let v0 = MortarView()
        let v1 = MortarView()
        let v2 = MortarView()
        let v3 = MortarView()
        let v4 = MortarView()
        let v5 = MortarView()
        
        self.container |+| [v0, v1, v2, v3, v4, v5]
        
        v0 |=| self.container.m_height
        
        MortarDefault.priority.set(base: .low)
        
        v1 |=| self.container.m_height
        
        MortarDefault.priority.set(base: .medium)
        
        v2 |=| self.container.m_height
        
        MortarDefault.priority.set(base: .high)
        
        v3 |=| self.container.m_height
        
        MortarDefault.priority.set(base: .required)
        
        v4 |=| self.container.m_height
        
        MortarDefault.priority.set(base: 300)
        
        v5 |=| self.container.m_height
        
        MortarDefault.priority.set(base: .medium)
        
        XCTAssertEqual(self.container.constraints[0].priority.rawValue, MortarAliasLayoutPriorityDefaultRequired.rawValue,    "Priority mismatch")
        XCTAssertEqual(self.container.constraints[1].priority.rawValue, MortarAliasLayoutPriorityDefaultLow.rawValue,         "Priority mismatch")
        XCTAssertEqual(self.container.constraints[2].priority.rawValue, MortarAliasLayoutPriorityDefaultMedium.rawValue,      "Priority mismatch")
        XCTAssertEqual(self.container.constraints[3].priority.rawValue, MortarAliasLayoutPriorityDefaultHigh.rawValue,        "Priority mismatch")
        XCTAssertEqual(self.container.constraints[4].priority.rawValue, MortarAliasLayoutPriorityDefaultRequired.rawValue,    "Priority mismatch")
        XCTAssertEqual(self.container.constraints[5].priority.rawValue, 300,                                                  "Priority mismatch")
    }
    
    func testBasicPriorityStack() {
        let v0 = MortarView()
        let v1 = MortarView()
        let v2 = MortarView()
        let v3 = MortarView()
        let v4 = MortarView()
        let v5 = MortarView()
        let v6 = MortarView()
        let v7 = MortarView()
        let v8 = MortarView()
        
        self.container |+| [v0, v1, v2, v3, v4, v5, v6, v7, v8]
        
        v0 |=| self.container.m_height
        v1 |=| self.container.m_height ! .low
        v2 |=| self.container.m_height ! .medium
        
        MortarDefault.priority.push(.high)
        
        v3 |=| self.container.m_height ! .required
        v4 |=| self.container.m_height ! .low
        v5 |=| self.container.m_height
        
        MortarDefault.priority.pop()
        
        MortarDefault.priority.push(.required)
        
        v6 |=| self.container.m_height ! .low
        
        MortarDefault.priority.push(400)
        
        v7 |=| self.container.m_height
        v8 |=| self.container.m_height ! .required
        
        MortarDefault.priority.pop()
        
        MortarDefault.priority.pop()
        
        
        
        XCTAssertEqual(self.container.constraints[0].priority.rawValue, MortarAliasLayoutPriorityDefaultMedium.rawValue,      "Priority mismatch")
        XCTAssertEqual(self.container.constraints[1].priority.rawValue, MortarAliasLayoutPriorityDefaultLow.rawValue,         "Priority mismatch")
        XCTAssertEqual(self.container.constraints[2].priority.rawValue, MortarAliasLayoutPriorityDefaultMedium.rawValue,      "Priority mismatch")
        XCTAssertEqual(self.container.constraints[3].priority.rawValue, MortarAliasLayoutPriorityDefaultRequired.rawValue,    "Priority mismatch")
        XCTAssertEqual(self.container.constraints[4].priority.rawValue, MortarAliasLayoutPriorityDefaultLow.rawValue,         "Priority mismatch")
        XCTAssertEqual(self.container.constraints[5].priority.rawValue, MortarAliasLayoutPriorityDefaultHigh.rawValue,        "Priority mismatch")
        XCTAssertEqual(self.container.constraints[6].priority.rawValue, MortarAliasLayoutPriorityDefaultLow.rawValue,         "Priority mismatch")
        XCTAssertEqual(self.container.constraints[7].priority.rawValue, 400,                                                  "Priority mismatch")
        XCTAssertEqual(self.container.constraints[8].priority.rawValue, MortarAliasLayoutPriorityDefaultRequired.rawValue,    "Priority mismatch")
    }
    
    func testChangePriority() {
        let v0 = MortarView()
        let v1 = MortarView()
        
        self.container |+| [v0, v1]
        
        let c1 = v0 |=| self.container.m_height ! .low
        let c2 = v1 |=| self.container.m_height ! .high
        
        XCTAssertEqual(self.container.constraints[0].priority.rawValue, MortarAliasLayoutPriorityDefaultLow.rawValue,  "Priority mismatch")
        XCTAssertEqual(self.container.constraints[1].priority.rawValue, MortarAliasLayoutPriorityDefaultHigh.rawValue, "Priority mismatch")
        
        c1.changePriority(to: .high)
        c2.changePriority(to: 300)
        
        XCTAssertEqual(self.container.constraints[0].priority.rawValue, MortarAliasLayoutPriorityDefaultHigh.rawValue, "Priority mismatch")
        XCTAssertEqual(self.container.constraints[1].priority.rawValue, 300,                                           "Priority mismatch")
    }
    
    func testChangePriorityGroup() {
        let v0 = MortarView()
        let v1 = MortarView()
        
        self.container |+| [v0, v1]
        
        let g1 = [
            v0 |=| self.container.m_height ! .low,
            v1 |=| self.container.m_height ! .high
        ]
        
        XCTAssertEqual(self.container.constraints[0].priority.rawValue, MortarAliasLayoutPriorityDefaultLow.rawValue,  "Priority mismatch")
        XCTAssertEqual(self.container.constraints[1].priority.rawValue, MortarAliasLayoutPriorityDefaultHigh.rawValue, "Priority mismatch")
        
        g1.changePriority(to: 300)
        
        XCTAssertEqual(self.container.constraints[0].priority.rawValue, 300,                         "Priority mismatch")
        XCTAssertEqual(self.container.constraints[1].priority.rawValue, 300,                         "Priority mismatch")
    }
 
    func testTuplePriority() {
        let v = MortarView()
        
        self.container |+| v
        
        v.m_size |=| (self.container.m_height ! .high, self.container.m_width + 20 ! .low)
        
        XCTAssertEqual(self.container.constraints[0].priority.rawValue, MortarAliasLayoutPriorityDefaultHigh.rawValue, "Priority mismatch")
        XCTAssertEqual(self.container.constraints[1].priority.rawValue, MortarAliasLayoutPriorityDefaultLow.rawValue,  "Priority mismatch")
    }       

    func testRestoreDefaultPriority() {
        MortarDefault.priority.set(base: .required)
    }
    
    func testReplace() {
        let v = MortarView()
        
        self.container |+| v
        
        let c1 = v.m_sides |=| self.container
        let c2 = v.m_width |=| self.container ~~ .deactivated
        
        XCTAssertEqual(self.container.constraints.count, 2, "Should have 4 constraints installed (ancestor)")
        XCTAssertEqual(v.constraints.count, 0, "Should have 0 constraints installed (constraints installed on ancestor)")
        
        c1.replace(with: c2)
        
        XCTAssertEqual(self.container.constraints.count, 1, "Should have 1 constraints installed (replaced)")
        XCTAssertEqual(v.constraints.count, 0, "Should have 0 constraints installed (constraints installed on ancestor)")
        
        c2.replace(with: c1)
        
        XCTAssertEqual(self.container.constraints.count, 2, "Should have 4 constraints installed (activated)")
        XCTAssertEqual(v.constraints.count, 0, "Should have 0 constraints installed (constraints installed on ancestor)")
    }
    
    func testReplaceGroup() {
        let v = MortarView()

        self.container |+| v
        
        let g1 = [
            v.m_sides |=| self.container,
            v.m_caps  |=| self.container,
        ]
        
        let g2 = [
            v.m_width |=| self.container
        ] ~~ .deactivated
        
        XCTAssertEqual(self.container.constraints.count, 4, "Should have 4 constraints installed (ancestor)")
        XCTAssertEqual(v.constraints.count, 0, "Should have 0 constraints installed (constraints installed on ancestor)")
        
        g1.replace(with: g2)
        
        XCTAssertEqual(self.container.constraints.count, 1, "Should have 1 constraints installed (replaced)")
        XCTAssertEqual(v.constraints.count, 0, "Should have 0 constraints installed (constraints installed on ancestor)")
        
        g2.replace(with: g1)
        
        XCTAssertEqual(self.container.constraints.count, 4, "Should have 4 constraints installed (activated)")
        XCTAssertEqual(v.constraints.count, 0, "Should have 0 constraints installed (constraints installed on ancestor)")
    }
    
    func testCreate() {
        let v = MortarView.create {
            $0.backgroundColor = .red
        }
        
        self.container |+| v
        
        let g1 = [
            v.m_sides |=| self.container,
            v.m_caps  |=| self.container,
            ]
        
        let g2 = [
            v.m_width |=| self.container
            ] ~~ .deactivated
        
        XCTAssertEqual(self.container.constraints.count, 4, "Should have 4 constraints installed (ancestor)")
        XCTAssertEqual(v.constraints.count, 0, "Should have 0 constraints installed (constraints installed on ancestor)")
        
        g1.replace(with: g2)
        
        XCTAssertEqual(self.container.constraints.count, 1, "Should have 1 constraints installed (replaced)")
        XCTAssertEqual(v.constraints.count, 0, "Should have 0 constraints installed (constraints installed on ancestor)")
        
        g2.replace(with: g1)
        
        XCTAssertEqual(self.container.constraints.count, 4, "Should have 4 constraints installed (activated)")
        XCTAssertEqual(v.constraints.count, 0, "Should have 0 constraints installed (constraints installed on ancestor)")
    }

    func testCreateImplicit() {
        let v = MortarView {
            $0.backgroundColor = .red
        }

        self.container |+| v

        let g1 = [
            v.m_sides |=| self.container,
            v.m_caps  |=| self.container,
            ]

        let g2 = [
            v.m_width |=| self.container
            ] ~~ .deactivated

        XCTAssertEqual(self.container.constraints.count, 4, "Should have 4 constraints installed (ancestor)")
        XCTAssertEqual(v.constraints.count, 0, "Should have 0 constraints installed (constraints installed on ancestor)")

        g1.replace(with: g2)

        XCTAssertEqual(self.container.constraints.count, 1, "Should have 1 constraints installed (replaced)")
        XCTAssertEqual(v.constraints.count, 0, "Should have 0 constraints installed (constraints installed on ancestor)")

        g2.replace(with: g1)

        XCTAssertEqual(self.container.constraints.count, 4, "Should have 4 constraints installed (activated)")
        XCTAssertEqual(v.constraints.count, 0, "Should have 0 constraints installed (constraints installed on ancestor)")
    }

    func testLayoutGuide() {
        #if os(iOS) || os(tvOS)
            if #available(iOS 11.0, *) {
                let vc = UIViewController()
                let v1 = UIView()
                
                vc.view.addSubview(v1)
                
                v1.m_top |=| vc.view.safeAreaLayoutGuide.m_top
                v1.m_bottom |=| vc.view.layoutMarginsGuide.m_top
            }
        #endif
    }
    
    func testCompression() {
        let v1 = MortarView()
        let v2 = MortarView()
        let v3 = MortarView()
        
        v1.m_compResist  = 343
        v2.m_compResistH = 341
        v3.m_compResistV = 342
        
        XCTAssertEqual(v1.m_compResistH.rawValue, 343, "Compression Issue")
        XCTAssertEqual(v1.m_compResistV.rawValue, 343, "Compression Issue")
        
        XCTAssertEqual(v2.m_compResistH.rawValue, 341, "Compression Issue")
        XCTAssertNotEqual(v2.m_compResistV.rawValue, 341, "Compression Issue")
        
        XCTAssertNotEqual(v3.m_compResistH.rawValue, 342, "Compression Issue")
        XCTAssertEqual(v3.m_compResistV.rawValue, 342, "Compression Issue")
    }
    
    func testHugging() {
        let v1 = MortarView()
        let v2 = MortarView()
        let v3 = MortarView()
        
        v1.m_hugging  = 343
        v2.m_huggingH = 341
        v3.m_huggingV = 342
        
        XCTAssertEqual(v1.m_huggingH.rawValue, 343, "Hugging Issue")
        XCTAssertEqual(v1.m_huggingV.rawValue, 343, "Hugging Issue")
        
        XCTAssertEqual(v2.m_huggingH.rawValue, 341, "Hugging Issue")
        XCTAssertNotEqual(v2.m_huggingV.rawValue, 341, "Hugging Issue")
        
        XCTAssertNotEqual(v3.m_huggingH.rawValue, 342, "Hugging Issue")
        XCTAssertEqual(v3.m_huggingV.rawValue, 342, "Hugging Issue")
    }
    
    func XCTAssertApprox(_ v1: CGFloat, _ v2: CGFloat, _ err: String) {
        let closeEnough = abs(v1 - v2) < 0.1
        XCTAssertEqual(closeEnough, true, err)
    }
    
    #if os(iOS)
    func testVFL1() {
        let v1 = MortarView()
        let v2 = MortarView()
        let v3 = MortarView()
        
        v1 |+| [v2, v3]
        
        v1.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        v1 |>> v2[~~1] | v3[~~1]
        v1 |^^ v2[~~1] | v3[~~3]
        v1.layoutIfNeeded()
        
        XCTAssertEqual(v2.bounds.size.width, 50, "VFL Issue A")
        XCTAssertEqual(v3.bounds.size.width, 50, "VFL Issue B")
        
        XCTAssertEqual(v2.bounds.size.height, 25, "VFL Issue C")
        XCTAssertEqual(v3.bounds.size.height, 75, "VFL Issue D")
    }
    
    func testVFL2() {
        let v1 = MortarView()
        let v2 = MortarView()
        let v3 = MortarView()
        let v4 = MortarView()
        
        v1 |+| [v2, v3, v4]
        
        v1.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        v4.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        
        v1 |> v2[~~1] | v3[~~1] <| v4
        v1 |^ v2[~~1] | v3[~~3] ^| v4
        v1.layoutIfNeeded()
        
        XCTAssertEqual(v2.frame.size.width, 100, "VFL Issue A")
        XCTAssertEqual(v3.frame.size.width, 100, "VFL Issue B")
        XCTAssertEqual(v3.frame.origin.x, 100, "VFL Issue B")
        
        XCTAssertEqual(v2.frame.size.height, 50, "VFL Issue C")
        XCTAssertEqual(v3.frame.size.height, 150, "VFL Issue D")
        XCTAssertEqual(v3.frame.origin.y, 50, "VFL Issue B")
    }
    
    func testVFL3() {
        let v1 = MortarView()
        let v2 = MortarView()
        let v3 = MortarView()
        let v4 = MortarView()
        let v5 = MortarView()
        
        v1 |+| [v2, v3, v4, v5]
        
        v1.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        v4.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        
        v1 |> v2[~~1] | [v3, v5][~~1] <| v4
        v1 |^ v2[~~1] | [v3, v5][~~3] ^| v4
        v1.layoutIfNeeded()
        
        XCTAssertEqual(v2.frame.size.width, 100, "VFL Issue A")
        XCTAssertEqual(v3.frame.size.width, 100, "VFL Issue B")
        XCTAssertEqual(v3.frame.origin.x, 100, "VFL Issue B")
        
        XCTAssertEqual(v2.frame.size.height, 50, "VFL Issue C")
        XCTAssertEqual(v3.frame.size.height, 150, "VFL Issue D")
        XCTAssertEqual(v3.frame.origin.y, 50, "VFL Issue B")
        
        XCTAssertEqual(v3.frame.origin.y, v5.frame.origin.y, "VFL Issue B")
        XCTAssertEqual(v3.frame.origin.x, v5.frame.origin.x, "VFL Issue B")
        XCTAssertEqual(v3.frame.size.width, v5.frame.size.width, "VFL Issue B")
        XCTAssertEqual(v3.frame.size.height, v5.frame.size.height, "VFL Issue B")
    }
    
    func testVFL4() {
        let v1 = MortarView()
        let v2 = MortarView()
        let v3 = MortarView()
        
        v1 |+| [v2, v3]
        
        v1.frame = CGRect(x: 0, y: 0, width: 124, height: 124)
        
        v1 ||> v2[~~1] || v3[~~1] <|| v1
        v1 ||^ v2[~~1] || v3[~~1] ^|| v1
        v1.layoutIfNeeded()
        
        XCTAssertEqual(v2.frame.size.width, 50, "VFL Issue A")
        XCTAssertEqual(v3.frame.size.width, 50, "VFL Issue B")
        XCTAssertEqual(v3.frame.origin.x, 66, "VFL Issue B")
        
        XCTAssertEqual(v2.frame.size.height, 50, "VFL Issue C")
        XCTAssertEqual(v3.frame.size.height, 50, "VFL Issue D")
        XCTAssertEqual(v3.frame.origin.y, 66, "VFL Issue B")
        
    }
    
    func testVFL5() {
        let c = MortarView()
        let v1 = MortarView()
        let v2 = MortarView()
        let v3 = MortarView()
        let l1 = TestLabel()
        let l2 = TestLabel()
        let l3 = TestLabel()

        l1.text = "wide string"
        l2.text = "tall\nstring"
        l2.numberOfLines = 0
        l3.text = "test"

        let l1size = l1.sizeThatFits(CGSize(width: 500, height: 500))
        let l2size = l2.sizeThatFits(CGSize(width: 500, height: 500))

        c.frame = CGRect(x: 0, y: 0, width: 500, height: 500)
        c |+| [v1, v2, v3, l1, l2, l3]

        c ||>> v1[~~1] || v2[~~2] || v3[==5] || l1 || l2 || l3[~~2]
        c ||^^ v1 || v2[==10] || v3[==5] || l1 || l2 || l3[==20]

        c.layoutIfNeeded()

        //check a few || paddings
        XCTAssertEqual(v1.frame.origin.x, 8, accuracy: 1, "Leftmost || pad")
        XCTAssertEqual(v1.frame.origin.y, 8, accuracy: 1, "Topmost || pad ")

        XCTAssertEqual(l1.frame.origin.x + l1.frame.size.width + 8, l2.frame.origin.x , accuracy: 1, "spot check inner horizontal || pad")
        XCTAssertEqual(l1.frame.origin.y + l1.frame.size.height + 8, l2.frame.origin.y , accuracy: 1, "spot check inner vertical || pad")

        XCTAssertEqual(l3.frame.origin.y + l3.frame.size.height + 8, 500, accuracy: 1, "Bottommost || pad")
        XCTAssertEqual(l3.frame.origin.x + l3.frame.size.width + 8, 500, accuracy: 1, "Rightmost || pad")

        //plain veiw sizes
        XCTAssertEqual(v1.frame.size.width, 0.5 * v2.frame.size.width, accuracy: 1, "v1,2 weighted widths")
        XCTAssertEqual(v1.frame.size.height, 500 - (8 * 7) - l1size.height - l2size.height - 20 - 10 - 5, accuracy:1, "v1 intinsic height w/ low content hugging")
        XCTAssertEqual(v2.frame.size.height, 10, accuracy: 1,"v2 fixed height")
        XCTAssertEqual(v3.frame.size.height, 5, accuracy: 1,"v3 fixed height")
        XCTAssertEqual(v3.frame.size.width, 5, accuracy: 1,"v3 fixed height")


        //label sizes
        XCTAssertEqual(l1.frame.size.width , l1size.width, accuracy: 1, "l1 instrinsic width")
        XCTAssertEqual(l1.frame.size.height , l1size.height, accuracy: 1, "l1 instrinsic height")

        XCTAssertEqual(l2.frame.size.width , l2size.width, accuracy: 1, "l2 instrinsic width")
        XCTAssertEqual(l2.frame.size.height , l2size.height, accuracy: 1, "l2 instrinsic height")

        XCTAssertGreaterThan(l1.frame.size.width , l2.frame.size.width, "l1 is wider than l2(more characters per line)")
        XCTAssertGreaterThan(l2.frame.size.height , l1.frame.size.height, "l2 is taller than l1 (it's milti-line)")

        XCTAssertEqual(l3.frame.size.width, v1.frame.size.width * 2, accuracy: 1,"l3 is weighted 2 horiontally")
        XCTAssertEqual(l3.frame.size.height, 20, accuracy: 1,"l3 is fixed 20px vertically")
    }

    func testVFL6() {
        let c = MortarView()
        let label = TestLabel()
        label.text = "This is three lines."
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping

        c |+| [label]
        c.frame = CGRect(x: 0, y: 0, width: 150, height: 150)

        c |>> 50 | label | 50
        c |^^ ~~1 | label | ~~1
        c.layoutIfNeeded()

        let lineHeight = label.sizeThatFits(CGSize(width: 500, height: 500)).height
        let lineLength = label.sizeThatFits(CGSize(width: 500, height: 500)).width

        XCTAssertEqual(label.frame.origin.x, 50, accuracy: 1, "Left indent")
        XCTAssertEqual(label.frame.size.height, lineHeight * ceil(lineLength/50), accuracy: 1, "Right indent")
        XCTAssertEqual(label.frame.origin.y, 150 - label.frame.origin.y - label.frame.size.height, accuracy: 1, "top/bottom pad are equal")
        let originalHeight = label.frame.size.height

        label.text = "This string is four lines."
        c.setNeedsLayout()
        c.layoutIfNeeded()

        let lineLength2 = label.sizeThatFits(CGSize(width: 500, height: 500)).width

        XCTAssertEqual(label.frame.origin.x, 50, accuracy: 1, "Left indent")
        XCTAssertEqual(label.frame.size.height, lineHeight * ceil(lineLength2/50), accuracy: 1, "Right indent")
        XCTAssertEqual(label.frame.origin.y, 150 - label.frame.origin.y - label.frame.size.height, accuracy: 1, "top/bottom pad are equal")
        XCTAssertGreaterThan(label.frame.size.height, originalHeight, "four line label shoudl be taller than 3 line label")
    }
    #endif

    #if os(iOS)
    @available(*, deprecated, message: "deprecated test")
    func testDeprecatedLayoutGuides() {
        let v1  = MortarView()
        let v2  = MortarView()
        let v3  = MortarView()
        let v4  = MortarView()
        let vc  = UIViewController()
        vc.view = MortarView()
        
        vc.view |+| [v1, v2, v3, v4]
        
        v1.m_top |=| vc.m_topLayoutGuideTop
        v2.m_top |=| vc.m_topLayoutGuideBottom
        v3.m_top |=| vc.m_bottomLayoutGuideTop
        v4.m_top |=| vc.m_bottomLayoutGuideBottom
        
        XCTAssertEqual(vc.view.constraints.count, 8, "Should have 4 constraints installed (ancestor)")
    }
  
    func testLayoutGuides() {
        let v1  = MortarView()
        let v2  = MortarView()
        let vc  = UIViewController()
        vc.view = MortarView()
        
        vc.view |+| [v1, v2]
        
        v1.m_top |=| vc.m_safeTop
        v2.m_top |=| vc.m_safeBottom
        
        XCTAssertEqual(vc.view.constraints.count, 6, "Should have 4 constraints installed (ancestor)")
    }
    #endif

    func testDeferredConstraints() {
        let sut = MortarView()
        self.container.addSubview(sut)
        sut |=| self.container.m_height

        self.container |+| [
            MortarView.create { _ in },
            MortarView.create { _ in } |+| [
                MortarView.create {
                    $0 |=| sut.m_height + 5
                },
                MortarView.create {
                    $0 |=| sut.m_height + 5
                }
            ]
        ]

        let v1 = self.container.subviews[1]
        let v2 = self.container.subviews[2]
        let v3 = v2.subviews[0]
        let v4 = v2.subviews[1]

        XCTAssertEqual(sut, self.container.subviews[0], "Hierarchy mismatch")

        XCTAssertEqual(v1.superview, self.container, "Hierarchy mismatch")
        XCTAssertEqual(v2.superview, self.container, "Hierarchy mismatch")
        XCTAssertEqual(v3.superview, v2, "Hierarchy mismatch")
        XCTAssertEqual(v4.superview, v2, "Hierarchy mismatch")

        self.container.layoutIfNeeded()

        XCTAssertEqual(v3.frame.size.height, MortarTests.CON_H + 5, "Frame mismatch")
        XCTAssertEqual(v4.frame.size.height, MortarTests.CON_H + 5, "Frame mismatch")
    }

    func testDeferredBuilder() {
        let sut = MortarView()
        self.container.addSubview(sut)
        sut |=| self.container.m_height

        self.container |+| { container in
            MortarView.create { _ in }
            MortarView.create {
                $0.m_height |=| 5
            } |+| { v2 in
                MortarView.create {
                    $0 |=| container.m_height + 5
                }
                MortarView.create {
                    $0 |=| v2.m_height + 5
                }
            }
        }

        let v1 = self.container.subviews[1]
        let v2 = self.container.subviews[2]
        let v3 = v2.subviews[0]
        let v4 = v2.subviews[1]

        XCTAssertEqual(sut, self.container.subviews[0], "Hierarchy mismatch")

        XCTAssertEqual(v1.superview, self.container, "Hierarchy mismatch")
        XCTAssertEqual(v2.superview, self.container, "Hierarchy mismatch")
        XCTAssertEqual(v3.superview, v2, "Hierarchy mismatch")
        XCTAssertEqual(v4.superview, v2, "Hierarchy mismatch")

        self.container.layoutIfNeeded()

        XCTAssertEqual(v3.frame.size.height, MortarTests.CON_H + 5, "Frame mismatch")
        XCTAssertEqual(v4.frame.size.height, 10, "Frame mismatch")
    }

    func testDeferredAddSubviewsBuilder() {
        let sut = MortarView()
        self.container.addSubview(sut)
        sut |=| self.container.m_height
        let injectMiddle = false

        self.container |+| { container in
            MortarView.create { _ in }
            MortarView.create {
                $0.m_height |=| 5
            } |+| { v2 in
                MortarView.create {
                    $0 |=| container.m_height + 5
                }
                injectMiddle ? MortarView.create {
                  $0 |=| v2.m_height + 100
                } : nil
                MortarView.create {
                    $0 |=| v2.m_height + 5
                }
            }
        }

        let v1 = self.container.subviews[1]
        let v2 = self.container.subviews[2]
        let v3 = v2.subviews[0]
        let v4 = v2.subviews[1]

        XCTAssertEqual(sut, self.container.subviews[0], "Hierarchy mismatch")

        XCTAssertEqual(v1.superview, self.container, "Hierarchy mismatch")
        XCTAssertEqual(v2.superview, self.container, "Hierarchy mismatch")
        XCTAssertEqual(v3.superview, v2, "Hierarchy mismatch")
        XCTAssertEqual(v4.superview, v2, "Hierarchy mismatch")

        self.container.layoutIfNeeded()

        XCTAssertEqual(v3.frame.size.height, MortarTests.CON_H + 5, "Frame mismatch")
        XCTAssertEqual(v4.frame.size.height, 10, "Frame mismatch")
    }
  
    func testAddSubviewsListBuilder() {
        let sut = MortarView()
        self.container.addSubview(sut)
        sut |=| self.container.m_height
        let inject = false
      
        self.container |+| { container in
            MortarView.create { _ in }
            inject ? MortarView.create {
                $0.m_height |=| 5
            } : nil
            (0..<10).map { _ in
                MortarView.create { _ in }
            }
        }

      XCTAssertEqual(self.container.subviews.count, 12, "Count mismatch")
    }

    #if os(iOS)
    func testStackViewDeferredAddSubviewsBuilder() {
        let sut = MortarView()
        self.container.addSubview(sut)
        sut |=| self.container.m_height

        self.container |+| { container in
            MortarView.create { _ in }
            UIStackView.create {
                $0.m_height |=| 5
            } |+| { v2 in
                MortarView.create {
                    $0 |=| container.m_height + 5
                }
                MortarView.create {
                    $0 |=| v2.m_height + 5
                }
            }
        }

        let v1 = self.container.subviews[1]
        let v2 = self.container.subviews[2]
        let v3 = v2.subviews[0]
        let v4 = v2.subviews[1]

        XCTAssertEqual(sut, self.container.subviews[0], "Hierarchy mismatch")

        XCTAssertEqual(v1.superview, self.container, "Hierarchy mismatch")
        XCTAssertEqual(v2.superview, self.container, "Hierarchy mismatch")
        XCTAssertEqual(v3.superview, v2, "Hierarchy mismatch")
        XCTAssertEqual(v4.superview, v2, "Hierarchy mismatch")

        self.container.layoutIfNeeded()

        XCTAssertEqual(v3.frame.size.height, MortarTests.CON_H + 5, "Frame mismatch")
        XCTAssertEqual(v4.frame.size.height, 10, "Frame mismatch")
    }

    func testStackViewCustomSpacing() {
        let sut = MortarView()
        self.container.addSubview(sut)
        sut |=| self.container.m_height

        self.container |+| { container in
            MortarView { _ in }
            UIStackView {
                $0.m_height |=| 5
            } |+| { v2 in
                MortarView {
                    $0 |=| container.m_height + 5
                    $0.m_customSpacingAfter = 8
                }
                MortarView {
                    $0 |=| v2.m_height + 5
                    $0.m_customSpacingAfter = 16
                }
                MortarView {
                    $0 |=| v2.m_height + 10
                }
            }
        }

        let v1 = self.container.subviews[1]
        let v2 = self.container.subviews[2] as! UIStackView
        let v3 = v2.subviews[0]
        let v4 = v2.subviews[1]
        let v5 = v2.subviews[2]

        XCTAssertEqual(sut, self.container.subviews[0], "Hierarchy mismatch")

        XCTAssertEqual(v1.superview, self.container, "Hierarchy mismatch")
        XCTAssertEqual(v2.superview, self.container, "Hierarchy mismatch")
        XCTAssertEqual(v3.superview, v2, "Hierarchy mismatch")
        XCTAssertEqual(v4.superview, v2, "Hierarchy mismatch")

        self.container.layoutIfNeeded()

        XCTAssertEqual(v3.frame.size.height, MortarTests.CON_H + 5, "Frame mismatch")
        XCTAssertEqual(v4.frame.size.height, 10, "Frame mismatch")
        XCTAssertEqual(v5.frame.size.height, 15, "Frame mismatch")

        XCTAssertEqual(v3.m_customSpacingAfter, 8)
        XCTAssertEqual(v4.m_customSpacingAfter, 16)
        XCTAssertEqual(v5.m_customSpacingAfter, nil)

        XCTAssertEqual(v2.customSpacing(after: v3), 8)
        XCTAssertEqual(v2.customSpacing(after: v4), 16)        
    }
    #endif
}

