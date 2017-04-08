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

#if os(iOS) || os(tvOS)
import UIKit
#else
import AppKit
#endif


/*
 
 | means edges are abutted
 || means edges are padded
 > means implicit trailing
 >> means no trailing
 > can have <| or <|| to give other side
 
 size.view |>
 size.view.m_right |>
 
 (can have either view or constraint on left side)
 
 | is divided by 0 points
 || is divided by default padding points
 
 if nothing is declared in a node except a view, it will
 be considered weight = 1
 
 if only weight-based float is declared it will create a
 ghost view with that weight
 
 self.view |^^ 50 | viewA | viewB[%3] || viewC[==40] |%50| viewD[%viewE]
 
 
 */

private let kMortarDefaultVFLPadding: CGFloat = 8
private let kMortarDefaultVFLPaddingNode: _MortarVFLNode = _MortarSizingNode(floatable: kMortarDefaultVFLPadding, sizingType: .equals).__asNode()

// MARK: - Data Structures

/// Sizing can either be explicit value or weight-based
public enum _MortarSizingType {
    case equals, weight
}

/// Return a completely non-interactive view for layout purposes
private func mGhostView() -> _MortarVFLGhostView {
    return _MortarVFLGhostView.m_create {
        $0.backgroundColor = .clear
        $0.alpha = 0
        $0.isUserInteractionEnabled = false
    }
}

/// Class override so that it is visible in UI interactive view as a ghost
public class _MortarVFLGhostView: MortarView {
    
}

/// Sizing node is a combination of a float/view + sizing type
public final class _MortarSizingNode {
    let floatable: MortarCGFloatable?
    let view: MortarView?
    let sizingType: _MortarSizingType
    
    init(floatable: MortarCGFloatable, sizingType: _MortarSizingType) {
        self.floatable  = floatable
        self.sizingType = sizingType
        self.view       = nil
    }
    
    init(view: MortarView) {
        self.view       = view
        self.sizingType = .equals
        self.floatable  = nil
    }
}

/// Nodes are anything inside the VFL statement divided by | or ||
public final class _MortarVFLNode {
    let view:       MortarView?
    var sizingNode: _MortarSizingNode
    
    init(view: MortarView? = nil, sizingNode: _MortarSizingNode) {
        self.view       = view
        self.sizingNode = sizingNode
    }
    
    func resolveSizingNode(ref: [ObjectIdentifier: _MortarVFLNode]) throws {
        while true {
            guard let refView = sizingNode.view else {
                // We stop when our size is based on a floatable, not a view
                return
            }
            
            guard let refNode = ref[ObjectIdentifier(refView)] else {
                try raise("You cannot reference a view for relative sizing unless it is also the base view for a node in the VFL statement")
                return
            }
            
            self.sizingNode = refNode.sizingNode
        }
    }
    
    var isFixedSizedPadding: Bool {
        return view == nil && sizingNode.sizingType == .equals && sizingNode.view == nil
    }
}

private func ==(lhs: _MortarVFLNode, rhs: _MortarVFLNode) -> Bool {
    return lhs === rhs
}

/// Captures a list with a bounded end
public final class _MortarVFLListCapture {
    let axis: MortarAxis
    var list: [_MortarVFLNode]
    
    var trailingView: MortarView?       = nil
    var trailingAttr: MortarAttribute?  = nil
    
    private(set) var leadingView: MortarView?        = nil
    private(set) var leadingAttr: MortarAttribute?   = nil
    
    fileprivate func setLeadingAttr(_ leadingAttr: MortarAttribute) {
        self.leadingAttr = leadingAttr
        if let view = leadingAttr.item as? MortarView {
            leadingView = view
        } else {
            NSException(name: NSExceptionName(rawValue: "Invalid attribute"),
                      reason: "Leading VFL attributes must be attached to a view",
                    userInfo: nil).raise()
        }
    }
    
    fileprivate func setLeadingView(_ leadingView: MortarView) {
        self.leadingView = leadingView
        self.leadingAttr = (axis == .horizontal) ? leadingView.m_left : leadingView.m_top
    }
    
    init(axis: MortarAxis, list: [_MortarVFLNode], trailingView: MortarView) {
        self.axis         = axis
        self.list         = list
        self.trailingView = trailingView
        self.trailingAttr = (axis == .horizontal) ? trailingView.m_right : trailingView.m_bottom
    }
    
    init(axis: MortarAxis, list: [_MortarVFLNode], trailingAttr: MortarAttribute) {
        self.axis         = axis
        self.list         = list
        self.trailingAttr = trailingAttr
        
        if let view = trailingAttr.item as? MortarView {
            self.trailingView = view
        } else {
            NSException(name: NSExceptionName(rawValue: "Invalid attribute"),
                      reason: "Trailing VFL attributes must be attached to a view",
                    userInfo: nil).raise()
        }
    }
}


// MARK: - Sizing Node Operators

prefix operator ~
prefix operator ==

public prefix func ~(view: MortarView) -> _MortarSizingNode {
    return _MortarSizingNode(view: view)
}

public prefix func ~(floatable: MortarCGFloatable) -> _MortarSizingNode {
    return _MortarSizingNode(floatable: floatable, sizingType: .weight)
}

public prefix func ==(view: MortarView) -> _MortarSizingNode {
    return _MortarSizingNode(view: view)
}

public prefix func ==(floatable: MortarCGFloatable) -> _MortarSizingNode {
    return _MortarSizingNode(floatable: floatable, sizingType: .equals)
}

// MARK: - Mortar view subscript -> VFL Node

public extension MortarView {
    public subscript(sizingNode: _MortarSizingNode) -> _MortarVFLNode {
        return _MortarVFLNode(view: self, sizingNode: sizingNode)
    }
}

// MARK: - Making things into VFL nodes

public protocol _MortarVFLNodable {
    func __asNode() -> _MortarVFLNode
}

extension CGFloat : _MortarVFLNodable {
    @inline(__always) public func __asNode() -> _MortarVFLNode {
        return _MortarVFLNode(sizingNode: _MortarSizingNode(floatable: self, sizingType: .equals))
    }
}

extension Int : _MortarVFLNodable {
    @inline(__always) public func __asNode() -> _MortarVFLNode {
        return _MortarVFLNode(sizingNode: _MortarSizingNode(floatable: self, sizingType: .equals))
    }
}

extension UInt : _MortarVFLNodable {
    @inline(__always) public func __asNode() -> _MortarVFLNode {
        return _MortarVFLNode(sizingNode: _MortarSizingNode(floatable: self, sizingType: .equals))
    }
}

extension Int64 : _MortarVFLNodable {
    @inline(__always) public func __asNode() -> _MortarVFLNode {
        return _MortarVFLNode(sizingNode: _MortarSizingNode(floatable: self, sizingType: .equals))
    }
}

extension UInt64 : _MortarVFLNodable {
    @inline(__always) public func __asNode() -> _MortarVFLNode {
        return _MortarVFLNode(sizingNode: _MortarSizingNode(floatable: self, sizingType: .equals))
    }
}

extension UInt32 : _MortarVFLNodable {
    @inline(__always) public func __asNode() -> _MortarVFLNode {
        return _MortarVFLNode(sizingNode: _MortarSizingNode(floatable: self, sizingType: .equals))
    }
}

extension Int32 : _MortarVFLNodable {
    @inline(__always) public func __asNode() -> _MortarVFLNode {
        return _MortarVFLNode(sizingNode: _MortarSizingNode(floatable: self, sizingType: .equals))
    }
}

extension Double : _MortarVFLNodable {
    @inline(__always) public func __asNode() -> _MortarVFLNode {
        return _MortarVFLNode(sizingNode: _MortarSizingNode(floatable: self, sizingType: .equals))
    }
}

extension Float : _MortarVFLNodable {
    @inline(__always) public func __asNode() -> _MortarVFLNode {
        return _MortarVFLNode(sizingNode: _MortarSizingNode(floatable: self, sizingType: .equals))
    }
}

extension _MortarSizingNode : _MortarVFLNodable {
    @inline(__always) public func __asNode() -> _MortarVFLNode {
        return _MortarVFLNode(sizingNode: self)
    }
}

extension _MortarVFLNode: _MortarVFLNodable {
    @inline(__always) public func __asNode() -> _MortarVFLNode {
        return self
    }
}


// MARK: - Divider Operator

precedencegroup MortarVFLDividerPrecendence {
    higherThan:     MortarVFLListCapturePrecendence
    lowerThan:      MultiplicationPrecedence
    associativity:  left
}

infix operator |  : MortarVFLDividerPrecendence
infix operator || : MortarVFLDividerPrecendence

// Accumulate Nodes into a list

public func |(lhs: _MortarVFLNodable, rhs: _MortarVFLNodable) -> [_MortarVFLNode] {
    return [lhs.__asNode(), rhs.__asNode()]
}

public func |(lhs: inout [_MortarVFLNode], rhs: _MortarVFLNodable) -> [_MortarVFLNode] {
    lhs.append(rhs.__asNode())
    return lhs
}

public func ||(lhs: _MortarVFLNodable, rhs: _MortarVFLNodable) -> [_MortarVFLNode] {
    return [lhs.__asNode(), kMortarDefaultVFLPaddingNode, rhs.__asNode()]
}

public func ||(lhs: inout [_MortarVFLNode], rhs: _MortarVFLNodable) -> [_MortarVFLNode] {
    lhs.append(kMortarDefaultVFLPaddingNode)
    lhs.append(rhs.__asNode())
    return lhs
}


// MARK: - List Capture

precedencegroup MortarVFLListCapturePrecendence {
    higherThan:     MortarVFLListBeginPrecendence
    associativity:  left
}

infix operator <|   : MortarVFLListCapturePrecendence
infix operator <||  : MortarVFLListCapturePrecendence
infix operator ^|   : MortarVFLListCapturePrecendence
infix operator ^||  : MortarVFLListCapturePrecendence

// Each list capture can take either a nodable or list on the left, and a view or attribute on the right

public func <|(lhs: _MortarVFLNodable, rhs: MortarView) -> _MortarVFLListCapture {
    return _MortarVFLListCapture(axis: .horizontal, list: [lhs.__asNode()], trailingView: rhs)
}

public func <|(lhs: [_MortarVFLNode], rhs: MortarView) -> _MortarVFLListCapture {
    return _MortarVFLListCapture(axis: .horizontal, list: lhs, trailingView: rhs)
}

public func <|(lhs: _MortarVFLNodable, rhs: MortarAttribute) -> _MortarVFLListCapture {
    return _MortarVFLListCapture(axis: .horizontal, list: [lhs.__asNode()], trailingAttr: rhs)
}

public func <|(lhs: [_MortarVFLNode], rhs: MortarAttribute) -> _MortarVFLListCapture {
    return _MortarVFLListCapture(axis: .horizontal, list: lhs, trailingAttr: rhs)
}

public func <||(lhs: _MortarVFLNodable, rhs: MortarView) -> _MortarVFLListCapture {
    return _MortarVFLListCapture(axis: .horizontal, list: [lhs.__asNode(), kMortarDefaultVFLPaddingNode], trailingView: rhs)
}

public func <||(lhs: inout [_MortarVFLNode], rhs: MortarView) -> _MortarVFLListCapture {
    lhs.append(kMortarDefaultVFLPaddingNode)
    return _MortarVFLListCapture(axis: .horizontal, list: lhs, trailingView: rhs)
}

public func <||(lhs: _MortarVFLNodable, rhs: MortarAttribute) -> _MortarVFLListCapture {
    return _MortarVFLListCapture(axis: .horizontal, list: [lhs.__asNode(), kMortarDefaultVFLPaddingNode], trailingAttr: rhs)
}

public func <||(lhs: inout [_MortarVFLNode], rhs: MortarAttribute) -> _MortarVFLListCapture {
    lhs.append(kMortarDefaultVFLPaddingNode)
    return _MortarVFLListCapture(axis: .horizontal, list: lhs, trailingAttr: rhs)
}

// Vertical 

public func ^|(lhs: _MortarVFLNodable, rhs: MortarView) -> _MortarVFLListCapture {
    return _MortarVFLListCapture(axis: .vertical, list: [lhs.__asNode()], trailingView: rhs)
}

public func ^|(lhs: [_MortarVFLNode], rhs: MortarView) -> _MortarVFLListCapture {
    return _MortarVFLListCapture(axis: .vertical, list: lhs, trailingView: rhs)
}

public func ^|(lhs: _MortarVFLNodable, rhs: MortarAttribute) -> _MortarVFLListCapture {
    return _MortarVFLListCapture(axis: .vertical, list: [lhs.__asNode()], trailingAttr: rhs)
}

public func ^|(lhs: [_MortarVFLNode], rhs: MortarAttribute) -> _MortarVFLListCapture {
    return _MortarVFLListCapture(axis: .vertical, list: lhs, trailingAttr: rhs)
}

public func ^||(lhs: _MortarVFLNodable, rhs: MortarView) -> _MortarVFLListCapture {
    return _MortarVFLListCapture(axis: .vertical, list: [lhs.__asNode(), kMortarDefaultVFLPaddingNode], trailingView: rhs)
}

public func ^||(lhs: inout [_MortarVFLNode], rhs: MortarView) -> _MortarVFLListCapture {
    lhs.append(kMortarDefaultVFLPaddingNode)
    return _MortarVFLListCapture(axis: .vertical, list: lhs, trailingView: rhs)
}

public func ^||(lhs: _MortarVFLNodable, rhs: MortarAttribute) -> _MortarVFLListCapture {
    return _MortarVFLListCapture(axis: .vertical, list: [lhs.__asNode(), kMortarDefaultVFLPaddingNode], trailingAttr: rhs)
}

public func ^||(lhs: inout [_MortarVFLNode], rhs: MortarAttribute) -> _MortarVFLListCapture {
    lhs.append(kMortarDefaultVFLPaddingNode)
    return _MortarVFLListCapture(axis: .vertical, list: lhs, trailingAttr: rhs)
}

// MARK: - Final Parsing

precedencegroup MortarVFLListBeginPrecendence {
    higherThan:     RangeFormationPrecedence
    associativity:  left
}

infix operator |>   : MortarVFLListBeginPrecendence
infix operator |>>  : MortarVFLListBeginPrecendence
infix operator ||>  : MortarVFLListBeginPrecendence
infix operator ||>> : MortarVFLListBeginPrecendence
infix operator |^   : MortarVFLListBeginPrecendence
infix operator |^^  : MortarVFLListBeginPrecendence
infix operator ||^  : MortarVFLListBeginPrecendence
infix operator ||^^ : MortarVFLListBeginPrecendence

// For one >, Left side can have a view or attribute, right size must have capture!
// For two >>, Left size must be view and right cannot be capture!

public func |>(lhs: MortarView, rhs: _MortarVFLListCapture) -> MortarGroup {
    if rhs.axis != .horizontal {
        NSException(name: NSExceptionName(rawValue: "Mortar VFL Operator Error"),
                  reason: "Mismatched VFL axis operators (e.g. |> with ^|)",
                userInfo: nil).raise()
    }
    rhs.setLeadingView(lhs)
    return try! rhs.toGroup()
}

public func |>(lhs: MortarAttribute, rhs: _MortarVFLListCapture) -> MortarGroup {
    if rhs.axis != .horizontal {
        NSException(name: NSExceptionName(rawValue: "Mortar VFL Operator Error"),
                  reason: "Mismatched VFL axis operators (e.g. |> with ^|)",
                userInfo: nil).raise()
    }
    rhs.setLeadingAttr(lhs)
    return try! rhs.toGroup()
}

public func ||>(lhs: MortarView, rhs: _MortarVFLListCapture) -> MortarGroup {
    if rhs.axis != .horizontal {
        NSException(name: NSExceptionName(rawValue: "Mortar VFL Operator Error"),
                  reason: "Mismatched VFL axis operators (e.g. |> with ^|)",
                userInfo: nil).raise()
    }
    rhs.list.insert(kMortarDefaultVFLPaddingNode, at: 0)
    rhs.setLeadingView(lhs)
    return try! rhs.toGroup()
}

public func ||>(lhs: MortarAttribute, rhs: _MortarVFLListCapture) -> MortarGroup {
    if rhs.axis != .horizontal {
        NSException(name: NSExceptionName(rawValue: "Mortar VFL Operator Error"),
                  reason: "Mismatched VFL axis operators (e.g. |> with ^|)",
                userInfo: nil).raise()
    }
    rhs.list.insert(kMortarDefaultVFLPaddingNode, at: 0)
    rhs.setLeadingAttr(lhs)
    return try! rhs.toGroup()
}

public func |>>(lhs: MortarView, rhs: _MortarVFLNodable) -> MortarGroup {
    return lhs |>> [rhs.__asNode()]
}

public func |>>(lhs: MortarView, rhs: [_MortarVFLNode]) -> MortarGroup {
    let capture = _MortarVFLListCapture(axis: .horizontal, list: rhs, trailingView: lhs)
    capture.setLeadingView(lhs)
    return try! capture.toGroup()
}

public func ||>>(lhs: MortarView, rhs: _MortarVFLNodable) -> MortarGroup {
    var nodeArray = [rhs.__asNode()]
    return lhs ||>> nodeArray
}

public func ||>>(lhs: MortarView, rhs: inout [_MortarVFLNode]) -> MortarGroup {
    rhs.insert(kMortarDefaultVFLPaddingNode, at: 0)
    let capture = _MortarVFLListCapture(axis: .horizontal, list: rhs, trailingView: lhs)
    capture.setLeadingView(lhs)
    return try! capture.toGroup()
}

// Vertical

public func |^(lhs: MortarView, rhs: _MortarVFLListCapture) -> MortarGroup {
    if rhs.axis != .vertical {
        NSException(name: NSExceptionName(rawValue: "Mortar VFL Operator Error"),
                  reason: "Mismatched VFL axis operators (e.g. |> with ^|)",
                userInfo: nil).raise()
    }
    rhs.setLeadingView(lhs)
    return try! rhs.toGroup()
}

public func |^(lhs: MortarAttribute, rhs: _MortarVFLListCapture) -> MortarGroup {
    if rhs.axis != .vertical {
        NSException(name: NSExceptionName(rawValue: "Mortar VFL Operator Error"),
                  reason: "Mismatched VFL axis operators (e.g. |> with ^|)",
                userInfo: nil).raise()
    }
    rhs.setLeadingAttr(lhs)
    return try! rhs.toGroup()
}

public func ||^(lhs: MortarView, rhs: _MortarVFLListCapture) -> MortarGroup {
    if rhs.axis != .vertical {
        NSException(name: NSExceptionName(rawValue: "Mortar VFL Operator Error"),
                  reason: "Mismatched VFL axis operators (e.g. |> with ^|)",
                userInfo: nil).raise()
    }
    rhs.list.insert(kMortarDefaultVFLPaddingNode, at: 0)
    rhs.setLeadingView(lhs)
    return try! rhs.toGroup()
}

public func ||^(lhs: MortarAttribute, rhs: _MortarVFLListCapture) -> MortarGroup {
    if rhs.axis != .vertical {
        NSException(name: NSExceptionName(rawValue: "Mortar VFL Operator Error"),
                  reason: "Mismatched VFL axis operators (e.g. |> with ^|)",
                userInfo: nil).raise()
    }
    rhs.list.insert(kMortarDefaultVFLPaddingNode, at: 0)
    rhs.setLeadingAttr(lhs)
    return try! rhs.toGroup()
}

public func |^^(lhs: MortarView, rhs: _MortarVFLNodable) -> MortarGroup {
    return lhs |^^ [rhs.__asNode()]
}

public func |^^(lhs: MortarView, rhs: [_MortarVFLNode]) -> MortarGroup {
    let capture = _MortarVFLListCapture(axis: .vertical, list: rhs, trailingView: lhs)
    capture.setLeadingView(lhs)
    return try! capture.toGroup()
}

public func ||^^(lhs: MortarView, rhs: _MortarVFLNodable) -> MortarGroup {
    var nodeArray = [rhs.__asNode()]
    return lhs ||^^ nodeArray
}

public func ||^^(lhs: MortarView, rhs: inout [_MortarVFLNode]) -> MortarGroup {
    rhs.insert(kMortarDefaultVFLPaddingNode, at: 0)
    let capture = _MortarVFLListCapture(axis: .vertical, list: rhs, trailingView: lhs)
    capture.setLeadingView(lhs)
    return try! capture.toGroup()
}

// MARK: - Actual work!

private func raise(_ reason: String) throws {
    NSException(name: NSExceptionName(rawValue: "Mortar VFL Parsing Error"),
              reason: reason,
            userInfo: nil).raise()
}

fileprivate extension _MortarVFLListCapture {
    
    fileprivate func toGroup() throws -> MortarGroup {
        // Basic sanity
        guard let leadingView  = self.leadingView,
              let leadingAttr  = self.leadingAttr,
              let trailingView = self.trailingView,
              let trailingAttr = self.trailingAttr
        else {
            try! raise("missing border views")
            return []
        }
        
        // Tracks nodes by their view
        var nodeForView: [ObjectIdentifier: _MortarVFLNode] = [:]
        
        // There must be at least one weight-based node
        var weightNodeCount: Int = 0
        
        // There must be at least one view-based node
        var hasViewNode: Bool = false
        
        for node in self.list {
            if node.sizingNode.sizingType == .weight {
                weightNodeCount += 1
            }
            
            if let view = node.view {
                hasViewNode = true
                guard nodeForView[ObjectIdentifier(view)] == nil else {
                    try! raise("The same view cannot appaer multiple times in the VFL list")
                    return []
                }
                nodeForView[ObjectIdentifier(view)] = node
            }
        }
        
        guard hasViewNode else {
            try! raise("You must have at least one view in the VFL list")
            return []
        }
        
        guard weightNodeCount > 0 else {
            try! raise("You must have at least one weight-based node in the VFL list.  If you do not need weight-based constraints, use normal Mortar operators.")
            return []
        }
        
        // Resolve sizingNodes pointing to other views
        for node in self.list {
            try! node.resolveSizingNode(ref: nodeForView)
        }
        
        // Verify that there are no adjacent nodes that are simply constant padding
        if self.list.count > 1 {
            for index in 0 ..< (self.list.count - 1) {
                if self.list[index].isFixedSizedPadding &&
                   self.list[index+1].isFixedSizedPadding {
                    if (self.list[index] == kMortarDefaultVFLPaddingNode) ||
                       (self.list[index+1] == kMortarDefaultVFLPaddingNode) {
                        try! raise("At index \(index) and \(index+1) you have two adjacent fixed-size padding entries.  You must merge these.  One or more of these are default padding nodes created by use of the || operator.  These cannot be adjacent to other fixes-size padding.")
                    } else {
                        try! raise("At index \(index) and \(index+1) you have two adjacent fixed-size padding entries.  You must merge these.")
                    }
                    return []
                }
            }
        }
        
        return []
    }
    
}
