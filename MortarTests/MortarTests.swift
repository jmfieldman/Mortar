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
        
        /* Installs 4 constraints (one for each edge) */
        v.m_edges |=| self.container
        
        XCTAssertEqual(self.container.constraints.count, 4, "Should have 4 constraints installed (ancestor)")
        XCTAssertEqual(v.constraints.count, 0, "Should have 0 constraints installed (constraints installed on ancestor)")
    }
    
    func testBasicActivatationToggle() {
        let v = MortarView()
        
        self.container |+| v
        
        /* Installs 4 constraints (one for each edge) */
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

    func testBasicFrame() {
        let v = MortarView()
        
        self.container |+| v
        
        /* Installs 4 constraints (one for each edge) */
        v.m_edges |=| self.container
        
        self.container.layoutIfNeeded()
        
        XCTAssertEqual(v.frame.origin.x, 0, "Frame mismatch")
        XCTAssertEqual(v.frame.origin.y, 0, "Frame mismatch")
        XCTAssertEqual(v.frame.size.width,  MortarTests.CON_W, "Frame mismatch")
        XCTAssertEqual(v.frame.size.height, MortarTests.CON_H, "Frame mismatch")
    }
    
}

