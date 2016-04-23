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
        
        let c = v.m_edges |=| self.container ~~ .Deactivated
        
        XCTAssertEqual(self.container.constraints.count, 0, "Should have 4 constraints installed (ancestor)")
        XCTAssertEqual(v.constraints.count, 0, "Should have 0 constraints installed (constraints installed on ancestor)")
        
        c ~~ .Activated
        
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
        ] ~~ .Deactivated
        
        XCTAssertEqual(self.container.constraints.count, 0, "Should have 8 constraints installed (ancestor)")
        XCTAssertEqual(v1.constraints.count, 0, "Should have 0 constraints installed (constraints installed on ancestor)")
        XCTAssertEqual(v2.constraints.count, 0, "Should have 0 constraints installed (constraints installed on ancestor)")
        
        c ~~ .Activated
        
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
    
        [v1, v2].m_size |=| (7, 11) ! .Required
        [v3, v4]        |=| v1 ! .Required
        
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
        v1 |=| self.container.m_height ! .Low
        v2 |=| self.container.m_height ! .Default
        v3 |=| self.container.m_height ! .High
        v4 |=| self.container.m_height ! .Required
        v5 |=| self.container.m_height ! 300
        
        XCTAssertEqual(self.container.constraints[0].priority, MortarAliasLayoutPriorityDefaultNormal,     "Priority mismatch")
        XCTAssertEqual(self.container.constraints[1].priority, MortarAliasLayoutPriorityDefaultLow,  "Priority mismatch")
        XCTAssertEqual(self.container.constraints[2].priority, MortarAliasLayoutPriorityDefaultNormal,     "Priority mismatch")
        XCTAssertEqual(self.container.constraints[3].priority, MortarAliasLayoutPriorityDefaultHigh, "Priority mismatch")
        XCTAssertEqual(self.container.constraints[4].priority, MortarAliasLayoutPriorityDefaultRequired,    "Priority mismatch")
        XCTAssertEqual(self.container.constraints[5].priority, 300,                         "Priority mismatch")
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
        v1 |=| self.container.m_height ! .Low
        v2 |=| self.container.m_height ! .Default
        
        MortarDefault.Priority.push(.High)
        
        v3 |=| self.container.m_height ! .Required
        v4 |=| self.container.m_height ! .Low
        v5 |=| self.container.m_height
        
        MortarDefault.Priority.pop()
        
        MortarDefault.Priority.push(.Required)
        
        v6 |=| self.container.m_height ! .Low
        
        MortarDefault.Priority.push(400)
        
        v7 |=| self.container.m_height
        v8 |=| self.container.m_height ! .Required
        
        MortarDefault.Priority.pop()
        
        MortarDefault.Priority.pop()
        
        
        
        XCTAssertEqual(self.container.constraints[0].priority, MortarAliasLayoutPriorityDefaultNormal,      "Priority mismatch")
        XCTAssertEqual(self.container.constraints[1].priority, MortarAliasLayoutPriorityDefaultLow,         "Priority mismatch")
        XCTAssertEqual(self.container.constraints[2].priority, MortarAliasLayoutPriorityDefaultNormal,      "Priority mismatch")
        XCTAssertEqual(self.container.constraints[3].priority, MortarAliasLayoutPriorityDefaultRequired,    "Priority mismatch")
        XCTAssertEqual(self.container.constraints[4].priority, MortarAliasLayoutPriorityDefaultLow,         "Priority mismatch")
        XCTAssertEqual(self.container.constraints[5].priority, MortarAliasLayoutPriorityDefaultHigh,        "Priority mismatch")
        XCTAssertEqual(self.container.constraints[6].priority, MortarAliasLayoutPriorityDefaultLow,         "Priority mismatch")
        XCTAssertEqual(self.container.constraints[7].priority, 400,                                         "Priority mismatch")
        XCTAssertEqual(self.container.constraints[8].priority, MortarAliasLayoutPriorityDefaultRequired,    "Priority mismatch")
    }
    
    func testChangePriority() {
        let v0 = MortarView()
        let v1 = MortarView()
        
        self.container |+| [v0, v1]
        
        let c1 = v0 |=| self.container.m_height ! .Low
        let c2 = v1 |=| self.container.m_height ! .High
        
        XCTAssertEqual(self.container.constraints[0].priority, MortarAliasLayoutPriorityDefaultLow,  "Priority mismatch")
        XCTAssertEqual(self.container.constraints[1].priority, MortarAliasLayoutPriorityDefaultHigh, "Priority mismatch")
        
        c1.changePriority(.High)
        c2.changePriority(300)
        
        XCTAssertEqual(self.container.constraints[0].priority, MortarAliasLayoutPriorityDefaultHigh, "Priority mismatch")
        XCTAssertEqual(self.container.constraints[1].priority, 300,                         "Priority mismatch")
    }
    
    func testChangePriorityGroup() {
        let v0 = MortarView()
        let v1 = MortarView()
        
        self.container |+| [v0, v1]
        
        let g1 = [
            v0 |=| self.container.m_height ! .Low,
            v1 |=| self.container.m_height ! .High
        ]
        
        XCTAssertEqual(self.container.constraints[0].priority, MortarAliasLayoutPriorityDefaultLow,  "Priority mismatch")
        XCTAssertEqual(self.container.constraints[1].priority, MortarAliasLayoutPriorityDefaultHigh, "Priority mismatch")
        
        g1.changePriority(300)
        
        XCTAssertEqual(self.container.constraints[0].priority, 300,                         "Priority mismatch")
        XCTAssertEqual(self.container.constraints[1].priority, 300,                         "Priority mismatch")
    }
 
    func testTuplePriority() {
        let v = MortarView()
        
        self.container |+| v
        
        v.m_size |=| (self.container.m_height ! .High, self.container.m_width + 20 ! .Low)
        
        XCTAssertEqual(self.container.constraints[0].priority, MortarAliasLayoutPriorityDefaultHigh, "Priority mismatch")
        XCTAssertEqual(self.container.constraints[1].priority, MortarAliasLayoutPriorityDefaultLow,  "Priority mismatch")
    }       
    
    func testReplace() {
        let v = MortarView()
        
        self.container |+| v
        
        let c1 = v.m_sides |=| self.container
        let c2 = v.m_width |=| self.container ~~ .Deactivated
        
        XCTAssertEqual(self.container.constraints.count, 2, "Should have 4 constraints installed (ancestor)")
        XCTAssertEqual(v.constraints.count, 0, "Should have 0 constraints installed (constraints installed on ancestor)")
        
        c1.replaceWith(c2)
        
        XCTAssertEqual(self.container.constraints.count, 1, "Should have 1 constraints installed (replaced)")
        XCTAssertEqual(v.constraints.count, 0, "Should have 0 constraints installed (constraints installed on ancestor)")
        
        c2.replaceWith(c1)
        
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
        ] ~~ .Deactivated
        
        XCTAssertEqual(self.container.constraints.count, 4, "Should have 4 constraints installed (ancestor)")
        XCTAssertEqual(v.constraints.count, 0, "Should have 0 constraints installed (constraints installed on ancestor)")
        
        g1.replaceWith(g2)
        
        XCTAssertEqual(self.container.constraints.count, 1, "Should have 1 constraints installed (replaced)")
        XCTAssertEqual(v.constraints.count, 0, "Should have 0 constraints installed (constraints installed on ancestor)")
        
        g2.replaceWith(g1)
        
        XCTAssertEqual(self.container.constraints.count, 4, "Should have 4 constraints installed (activated)")
        XCTAssertEqual(v.constraints.count, 0, "Should have 0 constraints installed (constraints installed on ancestor)")
    }
    
    #if os(iOS)
    func testLayoutGuides() {
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
    #endif
}

