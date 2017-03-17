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
        
        XCTAssertEqual(self.container.constraints[0].priority, MortarAliasLayoutPriorityDefaultRequired,    "Priority mismatch")
        XCTAssertEqual(self.container.constraints[1].priority, MortarAliasLayoutPriorityDefaultLow,         "Priority mismatch")
        XCTAssertEqual(self.container.constraints[2].priority, MortarAliasLayoutPriorityDefaultMedium,      "Priority mismatch")
        XCTAssertEqual(self.container.constraints[3].priority, MortarAliasLayoutPriorityDefaultHigh,        "Priority mismatch")
        XCTAssertEqual(self.container.constraints[4].priority, MortarAliasLayoutPriorityDefaultRequired,    "Priority mismatch")
        XCTAssertEqual(self.container.constraints[5].priority, 300,                                         "Priority mismatch")
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
        
        XCTAssertEqual(self.container.constraints[0].priority, MortarAliasLayoutPriorityDefaultRequired,    "Priority mismatch")
        XCTAssertEqual(self.container.constraints[1].priority, MortarAliasLayoutPriorityDefaultLow,         "Priority mismatch")
        XCTAssertEqual(self.container.constraints[2].priority, MortarAliasLayoutPriorityDefaultMedium,      "Priority mismatch")
        XCTAssertEqual(self.container.constraints[3].priority, MortarAliasLayoutPriorityDefaultHigh,        "Priority mismatch")
        XCTAssertEqual(self.container.constraints[4].priority, MortarAliasLayoutPriorityDefaultRequired,    "Priority mismatch")
        XCTAssertEqual(self.container.constraints[5].priority, 300,                                         "Priority mismatch")
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
        
        
        
        XCTAssertEqual(self.container.constraints[0].priority, MortarAliasLayoutPriorityDefaultMedium,      "Priority mismatch")
        XCTAssertEqual(self.container.constraints[1].priority, MortarAliasLayoutPriorityDefaultLow,         "Priority mismatch")
        XCTAssertEqual(self.container.constraints[2].priority, MortarAliasLayoutPriorityDefaultMedium,      "Priority mismatch")
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
        
        let c1 = v0 |=| self.container.m_height ! .low
        let c2 = v1 |=| self.container.m_height ! .high
        
        XCTAssertEqual(self.container.constraints[0].priority, MortarAliasLayoutPriorityDefaultLow,  "Priority mismatch")
        XCTAssertEqual(self.container.constraints[1].priority, MortarAliasLayoutPriorityDefaultHigh, "Priority mismatch")
        
        c1.changePriority(to: .high)
        c2.changePriority(to: 300)
        
        XCTAssertEqual(self.container.constraints[0].priority, MortarAliasLayoutPriorityDefaultHigh, "Priority mismatch")
        XCTAssertEqual(self.container.constraints[1].priority, 300,                                  "Priority mismatch")
    }
    
    func testChangePriorityGroup() {
        let v0 = MortarView()
        let v1 = MortarView()
        
        self.container |+| [v0, v1]
        
        let g1 = [
            v0 |=| self.container.m_height ! .low,
            v1 |=| self.container.m_height ! .high
        ]
        
        XCTAssertEqual(self.container.constraints[0].priority, MortarAliasLayoutPriorityDefaultLow,  "Priority mismatch")
        XCTAssertEqual(self.container.constraints[1].priority, MortarAliasLayoutPriorityDefaultHigh, "Priority mismatch")
        
        g1.changePriority(to: 300)
        
        XCTAssertEqual(self.container.constraints[0].priority, 300,                         "Priority mismatch")
        XCTAssertEqual(self.container.constraints[1].priority, 300,                         "Priority mismatch")
    }
 
    func testTuplePriority() {
        let v = MortarView()
        
        self.container |+| v
        
        v.m_size |=| (self.container.m_height ! .high, self.container.m_width + 20 ! .low)
        
        XCTAssertEqual(self.container.constraints[0].priority, MortarAliasLayoutPriorityDefaultHigh, "Priority mismatch")
        XCTAssertEqual(self.container.constraints[1].priority, MortarAliasLayoutPriorityDefaultLow,  "Priority mismatch")
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
        let v = MortarView.m_create { obj in
            
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
    
    func testCompression() {
        let v1 = MortarView()
        let v2 = MortarView()
        let v3 = MortarView()
        
        v1.m_compResist  = 343
        v2.m_compResistH = 341
        v3.m_compResistV = 342
        
        XCTAssertEqual(v1.m_compResistH, 343, "Compression Issue")
        XCTAssertEqual(v1.m_compResistV, 343, "Compression Issue")
        
        XCTAssertEqual(v2.m_compResistH, 341, "Compression Issue")
        XCTAssertNotEqual(v2.m_compResistV, 341, "Compression Issue")
        
        XCTAssertNotEqual(v3.m_compResistH, 342, "Compression Issue")
        XCTAssertEqual(v3.m_compResistV, 342, "Compression Issue")
    }
    
    func testHugging() {
        let v1 = MortarView()
        let v2 = MortarView()
        let v3 = MortarView()
        
        v1.m_hugging  = 343
        v2.m_huggingH = 341
        v3.m_huggingV = 342
        
        XCTAssertEqual(v1.m_huggingH, 343, "Hugging Issue")
        XCTAssertEqual(v1.m_huggingV, 343, "Hugging Issue")
        
        XCTAssertEqual(v2.m_huggingH, 341, "Hugging Issue")
        XCTAssertNotEqual(v2.m_huggingV, 341, "Hugging Issue")
        
        XCTAssertNotEqual(v3.m_huggingH, 342, "Hugging Issue")
        XCTAssertEqual(v3.m_huggingV, 342, "Hugging Issue")
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

    func testLinearLayoutV() {
        let v1 = UILabel()
        let v2 = UILabel()
        let v3 = UILabel()
        let s1 = MortarPadView(wt:1)
        let s2 = MortarPadView(c:10)
        let s3 = MortarPadView(wt:0.5)

        let views = [v1, s1, v2, s2, v3, s3]
        self.container |+| views

        let linearConstraints = views.constrainV(inside: container)

        let nsConstraints = linearConstraints.flatMap { $0.layoutConstraints}

        let attributesIn = { (c: NSLayoutConstraint) -> [NSLayoutAttribute] in  [c.firstAttribute, c.secondAttribute] }
        let viewsIn = {(c: NSLayoutConstraint) -> [MortarView]  in [c.firstItem , c.secondItem].flatMap({$0 as? MortarView})}
        let spacersIn = { v in viewsIn(v).flatMap({$0 as? MortarPadView })}

        XCTAssertEqual(nsConstraints.count, 9, "Should create 9 constraints (7 edge pins, 1 spacer const, 1 spacer weight)")

        XCTAssertEqual(nsConstraints.filter{ $0.constant == 10 }.count, 1, "Should create 1 height 10 constraint")

        XCTAssertEqual(nsConstraints.filter({ c in
            spacersIn(c).contains(s3) && attributesIn(c).contains(.height)  && c.multiplier == 0.5
        }).count, 1, "Should create 1 weighted constraint connecting the two weighted spacers(s3 = S1.m_height * 0.5)")

        XCTAssertEqual(nsConstraints.filter({ c in  attributesIn(c).contains(.top) }).count, 6, "Should create 6 constrains with a m_top")

        XCTAssertEqual(nsConstraints.filter({ c in  attributesIn(c).contains(.bottom) }).count, 6, "Should create 6 constrains with a m_bottom")

        XCTAssertEqual(nsConstraints.filter({ c in
            (c.firstItem as? MortarPadView != nil  && c.firstAttribute == .top) || (c.secondItem as? MortarPadView != nil  && c.secondAttribute == .top)
        }).count, 3, "Should create 3 constrains on MortarPadView's top")
    }

    func testLinearLayoutH() {
        let v1 = UILabel()
        let v2 = UILabel()
        let v3 = UILabel()
        let s1 = MortarPadView(wt:1)
        let s2 = MortarPadView(c:10)
        let s3 = MortarPadView(wt:0.5)

        let views = [v1, s1, v2, s2, v3, s3]
        self.container |+| views

        let linearConstraints = views.constrainH(from: container.m_left, to: container.m_right)

        let nsConstraints = linearConstraints.flatMap { $0.layoutConstraints}

        let attributesIn = { (c: NSLayoutConstraint) -> [NSLayoutAttribute] in  [c.firstAttribute, c.secondAttribute] }
        let viewsIn = {(c: NSLayoutConstraint) -> [MortarView]  in [c.firstItem , c.secondItem].flatMap({$0 as? MortarView})}
        let spacersIn = { v in viewsIn(v).flatMap({$0 as? MortarPadView })}

        XCTAssertEqual(nsConstraints.count, 9, "Should create 9 constraints (7 edge pins, 1 spacer const, 1 spacer weight)")

        XCTAssertEqual(nsConstraints.filter{ $0.constant == 10 }.count, 1, "Should create 1 width 10 constraint")

        XCTAssertEqual(nsConstraints.filter({ c in
            spacersIn(c).contains(s3) && attributesIn(c).contains(.width)  && c.multiplier == 0.5
        }).count, 1, "Should create 1 weighted constraint connecting the two weighted spacers(s3 = S1.m_width * 0.5)")

        XCTAssertEqual(nsConstraints.filter({ c in  attributesIn(c).contains(.left) }).count, 6, "Should create 6 constrains with a m_top")

        XCTAssertEqual(nsConstraints.filter({ c in  attributesIn(c).contains(.right) }).count, 6, "Should create 6 constrains with a m_right")

        XCTAssertEqual(nsConstraints.filter({ c in
            (c.firstItem as? MortarPadView != nil  && c.firstAttribute == .left) || (c.secondItem as? MortarPadView != nil  && c.secondAttribute == .left)
        }).count, 3, "Should create 3 constrains on MortarPadView's left")
    }


    func testLinearLayoutHV() {

        let center = MortarPadView(c: 50, axis: .vertical).m_linear(wt: 1, axis: .horizontal)

        let viewsH = [UILabel().m_linear(wt: 1), center, UILabel().m_linear(wt: 1)]
        let viewsV = [UILabel().m_linear(wt: 1), center, UILabel().m_linear(wt: 1)]

        self.container |+| viewsH + viewsV

        let constraintsH = viewsH.constrainH(inside: container)
        let constraintsV = viewsV.constrainV(from: container.m_top)

        let nsConstraintsH = constraintsH.flatMap { $0.layoutConstraints}
        let nsConstraintsV = constraintsV.flatMap { $0.layoutConstraints}
        let nsConstraints = nsConstraintsH + nsConstraintsV

        let attributesIn = { (c: NSLayoutConstraint) -> [NSLayoutAttribute] in  [c.firstAttribute, c.secondAttribute] }

        XCTAssertEqual(nsConstraintsH.count, 6, "Should create 6 horizontal constraints")
        XCTAssertEqual(nsConstraintsV.count, 5, "Should create 6 vertical constraints")

        XCTAssertEqual(nsConstraints.filter{ $0.constant == 50 }.count, 1, "Should create 1 height 50 constraint")

        XCTAssertEqual(nsConstraints.filter({ c in  attributesIn(c).contains(.top) }).count, 3, "Should create 3 constrains with a m_top")
        XCTAssertEqual(nsConstraints.filter({ c in  attributesIn(c).contains(.bottom) }).count, 2, "Should create 2 constrains with a m_bottom")

        XCTAssertEqual(nsConstraints.filter({ c in  attributesIn(c).contains(.left) }).count, 3, "Should create 3 constrains with a m_left")
        XCTAssertEqual(nsConstraints.filter({ c in  attributesIn(c).contains(.right) }).count, 3, "Should create 3 constrains with a m_right")


        XCTAssertEqual(nsConstraints.filter({ c in
            attributesIn(c).contains(.width)  && c.multiplier == 1 && c.constant == 0
        }).count, 2, "Should create 2 constraints on width with multiplier 1")

        XCTAssertEqual(nsConstraints.filter({ c in
            attributesIn(c).contains(.height)  && c.multiplier == 1 && c.constant == 0
        }).count, 1, "Should create 1 constraint on height with multiplier 1")
    }

}

