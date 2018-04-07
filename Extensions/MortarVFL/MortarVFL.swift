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
    case equals, weight, intrinsic
}

/// Return a completely non-interactive view for layout purposes
private func mGhostView(in parent: MortarView?) -> _MortarVFLGhostView {
    let ghostView = _MortarVFLGhostView()
    #if os(iOS) || os(tvOS)
    ghostView.backgroundColor = .clear
    ghostView.alpha = 0
    ghostView.isUserInteractionEnabled = false
    #else
    ghostView.wantsLayer = true
    ghostView.layer?.backgroundColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 0)
    #endif
    parent?.addSubview(ghostView)
    return ghostView
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
    let views:      [MortarView]
    var sizingNode: _MortarSizingNode
    
    init(views: [MortarView] = [], sizingNode: _MortarSizingNode) {
        self.views      = views
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
            
            if refNode === self {
                try raise("You have a cyclical sizing reference loop in the VFL statement")
                return
            }
            
            self.sizingNode = refNode.sizingNode
        }
    }
    
    var isFixedSizedPadding: Bool {
        return views.count == 0 && sizingNode.sizingType == .equals && sizingNode.view == nil
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
        }
    }
    
    fileprivate func setLeadingView(_ leadingView: MortarView) {
        self.leadingView = leadingView
        self.leadingAttr = (axis == .horizontal) ? leadingView.m_left : leadingView.m_top
    }
    
    init(axis: MortarAxis, list: [_MortarVFLNode], trailingView: MortarView?) {
        self.axis         = axis
        self.list         = list
        self.trailingView = trailingView
        
        if let view = trailingView {
            self.trailingAttr = (axis == .horizontal) ? view.m_right : view.m_bottom
        }
    }
    
    init(axis: MortarAxis, list: [_MortarVFLNode], trailingAttr: MortarAttribute) {
        self.axis         = axis
        self.list         = list
        self.trailingAttr = trailingAttr
        
        if let view = trailingAttr.item as? MortarView {
            self.trailingView = view
        }
    }
}


// MARK: - Sizing Node Operators

prefix operator ~~
prefix operator ==

public prefix func ~~(view: MortarView) -> _MortarSizingNode {
    return _MortarSizingNode(view: view)
}

public prefix func ~~(floatable: MortarCGFloatable) -> _MortarSizingNode {
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
        return _MortarVFLNode(views: [self], sizingNode: sizingNode)
    }
}

// MARK: - Making an array of MortarView with size -> VFL Node

public extension Array where Element: MortarView {
    public subscript(sizingNode: _MortarSizingNode) -> _MortarVFLNode {
        return _MortarVFLNode(views: self, sizingNode: sizingNode)
    }
    
    public func __asNode() -> _MortarVFLNode {
        return _MortarVFLNode(views: self, sizingNode: _MortarSizingNode(floatable: 1, sizingType: .intrinsic))
    }
}

// MARK: - Making things into VFL nodes

public protocol _MortarVFLNodable {
    func __asNode() -> _MortarVFLNode
}

extension CGFloat : _MortarVFLNodable {
    public func __asNode() -> _MortarVFLNode {
        return _MortarVFLNode(sizingNode: _MortarSizingNode(floatable: self, sizingType: .equals))
    }
}

extension Int : _MortarVFLNodable {
    public func __asNode() -> _MortarVFLNode {
        return _MortarVFLNode(sizingNode: _MortarSizingNode(floatable: self, sizingType: .equals))
    }
}

extension UInt : _MortarVFLNodable {
    public func __asNode() -> _MortarVFLNode {
        return _MortarVFLNode(sizingNode: _MortarSizingNode(floatable: self, sizingType: .equals))
    }
}

extension Int64 : _MortarVFLNodable {
    public func __asNode() -> _MortarVFLNode {
        return _MortarVFLNode(sizingNode: _MortarSizingNode(floatable: self, sizingType: .equals))
    }
}

extension UInt64 : _MortarVFLNodable {
    public func __asNode() -> _MortarVFLNode {
        return _MortarVFLNode(sizingNode: _MortarSizingNode(floatable: self, sizingType: .equals))
    }
}

extension UInt32 : _MortarVFLNodable {
    public func __asNode() -> _MortarVFLNode {
        return _MortarVFLNode(sizingNode: _MortarSizingNode(floatable: self, sizingType: .equals))
    }
}

extension Int32 : _MortarVFLNodable {
    public func __asNode() -> _MortarVFLNode {
        return _MortarVFLNode(sizingNode: _MortarSizingNode(floatable: self, sizingType: .equals))
    }
}

extension Double : _MortarVFLNodable {
    public func __asNode() -> _MortarVFLNode {
        return _MortarVFLNode(sizingNode: _MortarSizingNode(floatable: self, sizingType: .equals))
    }
}

extension Float : _MortarVFLNodable {
    public func __asNode() -> _MortarVFLNode {
        return _MortarVFLNode(sizingNode: _MortarSizingNode(floatable: self, sizingType: .equals))
    }
}

extension MortarView : _MortarVFLNodable {
    public func __asNode() -> _MortarVFLNode {
        return _MortarVFLNode(views: [self], sizingNode: _MortarSizingNode(floatable: 1, sizingType: .intrinsic))
    }
}

extension _MortarSizingNode : _MortarVFLNodable {
    public func __asNode() -> _MortarVFLNode {
        return _MortarVFLNode(sizingNode: self)
    }
}

extension _MortarVFLNode: _MortarVFLNodable {
    public func __asNode() -> _MortarVFLNode {
        return self
    }
}


// MARK: - Divider Operator

// Accumulate Nodes into a list

public func |(lhs: _MortarVFLNodable, rhs: _MortarVFLNodable) -> [_MortarVFLNode] {
    return [lhs.__asNode(), rhs.__asNode()]
}

public func |(lhs: [_MortarVFLNode], rhs: _MortarVFLNodable) -> [_MortarVFLNode] {
    var accum = lhs
    accum.append(rhs.__asNode())
    return accum
}

public func ||(lhs: _MortarVFLNodable, rhs: _MortarVFLNodable) -> [_MortarVFLNode] {
    return [lhs.__asNode(), kMortarDefaultVFLPaddingNode, rhs.__asNode()]
}

public func ||(lhs: [_MortarVFLNode], rhs: _MortarVFLNodable) -> [_MortarVFLNode] {
    var accum = lhs
    accum.append(kMortarDefaultVFLPaddingNode)
    accum.append(rhs.__asNode())
    return accum
}

public func ||(lhs: _MortarVFLNodable, rhs: [_MortarVFLNode]) -> [_MortarVFLNode] {
    var accum = rhs
    accum.insert(kMortarDefaultVFLPaddingNode, at: 0)
    accum.insert(lhs.__asNode(), at: 0)
    return accum
}

public func ||(lhs: [_MortarVFLNode], rhs: [_MortarVFLNode]) -> [_MortarVFLNode] {
    var accum = lhs
    accum.append(kMortarDefaultVFLPaddingNode)
    rhs.forEach { accum.append($0) }
    return accum
}


// Now for arrays of MortarView

// |

public func |(lhs: [MortarView], rhs: _MortarVFLNodable) -> [_MortarVFLNode] {
    return [lhs.__asNode(), rhs.__asNode()]
}

public func |(lhs: [MortarView], rhs: [MortarView]) -> [_MortarVFLNode] {
    return [lhs.__asNode(), rhs.__asNode()]
}

public func |(lhs: _MortarVFLNodable, rhs: [MortarView]) -> [_MortarVFLNode] {
    return [lhs.__asNode(), rhs.__asNode()]
}

public func |(lhs: [_MortarVFLNode], rhs: [MortarView]) -> [_MortarVFLNode] {
    var accum = lhs
    accum.append(rhs.__asNode())
    return accum
}

// ||

public func ||(lhs: [MortarView], rhs: [MortarView]) -> [_MortarVFLNode] {
    return [lhs.__asNode(), kMortarDefaultVFLPaddingNode, rhs.__asNode()]
}

public func ||(lhs: [MortarView], rhs: _MortarVFLNodable) -> [_MortarVFLNode] {
    return [lhs.__asNode(), kMortarDefaultVFLPaddingNode, rhs.__asNode()]
}

public func ||(lhs: _MortarVFLNodable, rhs: [MortarView]) -> [_MortarVFLNode] {
    return [lhs.__asNode(), kMortarDefaultVFLPaddingNode, rhs.__asNode()]
}

public func ||(lhs: [MortarView], rhs: [_MortarVFLNode]) -> [_MortarVFLNode] {
    var accum = rhs
    accum.insert(kMortarDefaultVFLPaddingNode, at: 0)
    accum.insert(lhs.__asNode(), at: 0)
    return accum
}

public func ||(lhs: [_MortarVFLNode], rhs: [MortarView]) -> [_MortarVFLNode] {
    var accum = lhs
    accum.append(kMortarDefaultVFLPaddingNode)
    accum.append(rhs.__asNode())
    return accum
}

// MARK: - List Capture

precedencegroup MortarVFLListCapturePrecendence {
    higherThan:     MortarVFLListBeginPrecendence
    lowerThan:      LogicalDisjunctionPrecedence
    associativity:  left
}

infix operator <|   : MortarVFLListCapturePrecendence
infix operator <||  : MortarVFLListCapturePrecendence
infix operator ^|   : MortarVFLListCapturePrecendence
infix operator ^||  : MortarVFLListCapturePrecendence

// -- ! operators immediately create trailing-only constraint groups

infix operator <!   : MortarVFLListCapturePrecendence
infix operator <!!  : MortarVFLListCapturePrecendence
infix operator ^!   : MortarVFLListCapturePrecendence
infix operator ^!!  : MortarVFLListCapturePrecendence


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

public func <||(lhs: [_MortarVFLNode], rhs: MortarView) -> _MortarVFLListCapture {
    var accum = lhs
    accum.append(kMortarDefaultVFLPaddingNode)
    return _MortarVFLListCapture(axis: .horizontal, list: accum, trailingView: rhs)
}

public func <||(lhs: _MortarVFLNodable, rhs: MortarAttribute) -> _MortarVFLListCapture {
    return _MortarVFLListCapture(axis: .horizontal, list: [lhs.__asNode(), kMortarDefaultVFLPaddingNode], trailingAttr: rhs)
}

public func <||(lhs: [_MortarVFLNode], rhs: MortarAttribute) -> _MortarVFLListCapture {
    var accum = lhs
    accum.append(kMortarDefaultVFLPaddingNode)
    return _MortarVFLListCapture(axis: .horizontal, list: accum, trailingAttr: rhs)
}

// !

@discardableResult public func <!(lhs: _MortarVFLNodable, rhs: MortarView) -> MortarGroup {
    return try! (lhs <| rhs).toGroup()
}

@discardableResult public func <!(lhs: [_MortarVFLNode], rhs: MortarView) -> MortarGroup {
    return try! (lhs <| rhs).toGroup()
}

@discardableResult public func <!(lhs: _MortarVFLNodable, rhs: MortarAttribute) -> MortarGroup {
    return try! (lhs <| rhs).toGroup()
}

@discardableResult public func <!(lhs: [_MortarVFLNode], rhs: MortarAttribute) -> MortarGroup {
    return try! (lhs <| rhs).toGroup()
}

@discardableResult public func <!!(lhs: _MortarVFLNodable, rhs: MortarView) -> MortarGroup {
    return try! (lhs <|| rhs).toGroup()
}

@discardableResult public func <!!(lhs: [_MortarVFLNode], rhs: MortarView) -> MortarGroup {
    return try! (lhs <|| rhs).toGroup()
}

@discardableResult public func <!!(lhs: _MortarVFLNodable, rhs: MortarAttribute) -> MortarGroup {
    return try! (lhs <|| rhs).toGroup()
}

@discardableResult public func <!!(lhs: [_MortarVFLNode], rhs: MortarAttribute) -> MortarGroup {
    return try! (lhs <|| rhs).toGroup()
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

public func ^||(lhs: [_MortarVFLNode], rhs: MortarView) -> _MortarVFLListCapture {
    var accum = lhs
    accum.append(kMortarDefaultVFLPaddingNode)
    return _MortarVFLListCapture(axis: .vertical, list: accum, trailingView: rhs)
}

public func ^||(lhs: _MortarVFLNodable, rhs: MortarAttribute) -> _MortarVFLListCapture {
    return _MortarVFLListCapture(axis: .vertical, list: [lhs.__asNode(), kMortarDefaultVFLPaddingNode], trailingAttr: rhs)
}

public func ^||(lhs: [_MortarVFLNode], rhs: MortarAttribute) -> _MortarVFLListCapture {
    var accum = lhs
    accum.append(kMortarDefaultVFLPaddingNode)
    return _MortarVFLListCapture(axis: .vertical, list: accum, trailingAttr: rhs)
}

// !

@discardableResult public func ^!(lhs: _MortarVFLNodable, rhs: MortarView) -> MortarGroup {
    return try! (lhs ^| rhs).toGroup()
}

@discardableResult public func ^!(lhs: [_MortarVFLNode], rhs: MortarView) -> MortarGroup {
    return try! (lhs ^| rhs).toGroup()
}

@discardableResult public func ^!(lhs: _MortarVFLNodable, rhs: MortarAttribute) -> MortarGroup {
    return try! (lhs ^| rhs).toGroup()
}

@discardableResult public func ^!(lhs: [_MortarVFLNode], rhs: MortarAttribute) -> MortarGroup {
    return try! (lhs ^| rhs).toGroup()
}

@discardableResult public func ^!!(lhs: _MortarVFLNodable, rhs: MortarView) -> MortarGroup {
    return try! (lhs ^|| rhs).toGroup()
}

@discardableResult public func ^!!(lhs: [_MortarVFLNode], rhs: MortarView) -> MortarGroup {
    return try! (lhs ^|| rhs).toGroup()
}

@discardableResult public func ^!!(lhs: _MortarVFLNodable, rhs: MortarAttribute) -> MortarGroup {
    return try! (lhs ^|| rhs).toGroup()
}

@discardableResult public func ^!!(lhs: [_MortarVFLNode], rhs: MortarAttribute) -> MortarGroup {
    return try! (lhs ^|| rhs).toGroup()
}


// MARK: - Final Parsing

precedencegroup MortarVFLListBeginPrecendence {
    higherThan:     TernaryPrecedence
    lowerThan:      LogicalDisjunctionPrecedence
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

@discardableResult public func |>(lhs: MortarView, rhs: _MortarVFLListCapture) -> MortarGroup {
    if rhs.axis != .horizontal {
        NSException(name: NSExceptionName(rawValue: "Mortar VFL Operator Error"),
                  reason: "Mismatched VFL axis operators (e.g. |> with ^|)",
                userInfo: nil).raise()
    }
    rhs.setLeadingView(lhs)
    return try! rhs.toGroup()
}

@discardableResult public func |>(lhs: MortarView, rhs: _MortarVFLNodable) -> MortarGroup {
    return lhs |> [rhs.__asNode()]
}

@discardableResult public func |>(lhs: MortarView, rhs: [MortarView]) -> MortarGroup {
    return lhs |> [rhs.__asNode()]
}

@discardableResult public func |>(lhs: MortarView, rhs: [_MortarVFLNode]) -> MortarGroup {
    return lhs |> _MortarVFLListCapture(axis: .horizontal, list: rhs, trailingView: nil)
}

@discardableResult public func |>(lhs: MortarAttribute, rhs: _MortarVFLListCapture) -> MortarGroup {
    if rhs.axis != .horizontal {
        NSException(name: NSExceptionName(rawValue: "Mortar VFL Operator Error"),
                  reason: "Mismatched VFL axis operators (e.g. |> with ^|)",
                userInfo: nil).raise()
    }
    rhs.setLeadingAttr(lhs)
    return try! rhs.toGroup()
}

@discardableResult public func |>(lhs: MortarAttribute, rhs: _MortarVFLNodable) -> MortarGroup {
    return lhs |> [rhs.__asNode()]
}

@discardableResult public func |>(lhs: MortarAttribute, rhs: [MortarView]) -> MortarGroup {
    return lhs |> [rhs.__asNode()]
}

@discardableResult public func |>(lhs: MortarAttribute, rhs: [_MortarVFLNode]) -> MortarGroup {
    return lhs |> _MortarVFLListCapture(axis: .horizontal, list: rhs, trailingView: nil)
}

@discardableResult public func ||>(lhs: MortarView, rhs: _MortarVFLListCapture) -> MortarGroup {
    if rhs.axis != .horizontal {
        NSException(name: NSExceptionName(rawValue: "Mortar VFL Operator Error"),
                  reason: "Mismatched VFL axis operators (e.g. |> with ^|)",
                userInfo: nil).raise()
    }
    rhs.list.insert(kMortarDefaultVFLPaddingNode, at: 0)
    rhs.setLeadingView(lhs)
    return try! rhs.toGroup()
}

@discardableResult public func ||>(lhs: MortarView, rhs: _MortarVFLNodable) -> MortarGroup {
    return lhs ||> [rhs.__asNode()]
}

@discardableResult public func ||>(lhs: MortarView, rhs: [MortarView]) -> MortarGroup {
    return lhs ||> [rhs.__asNode()]
}

@discardableResult public func ||>(lhs: MortarView, rhs: [_MortarVFLNode]) -> MortarGroup {
    return lhs ||> _MortarVFLListCapture(axis: .horizontal, list: rhs, trailingView: nil)
}

@discardableResult public func ||>(lhs: MortarAttribute, rhs: _MortarVFLListCapture) -> MortarGroup {
    if rhs.axis != .horizontal {
        NSException(name: NSExceptionName(rawValue: "Mortar VFL Operator Error"),
                  reason: "Mismatched VFL axis operators (e.g. |> with ^|)",
                userInfo: nil).raise()
    }
    rhs.list.insert(kMortarDefaultVFLPaddingNode, at: 0)
    rhs.setLeadingAttr(lhs)
    return try! rhs.toGroup()
}

@discardableResult public func ||>(lhs: MortarAttribute, rhs: _MortarVFLNodable) -> MortarGroup {
    return lhs ||> [rhs.__asNode()]
}

@discardableResult public func ||>(lhs: MortarAttribute, rhs: [MortarView]) -> MortarGroup {
    return lhs ||> [rhs.__asNode()]
}

@discardableResult public func ||>(lhs: MortarAttribute, rhs: [_MortarVFLNode]) -> MortarGroup {
    return lhs ||> _MortarVFLListCapture(axis: .horizontal, list: rhs, trailingView: nil)
}


@discardableResult public func |>>(lhs: MortarView, rhs: _MortarVFLNodable) -> MortarGroup {
    return lhs |>> [rhs.__asNode()]
}

@discardableResult public func |>>(lhs: MortarView, rhs: [MortarView]) -> MortarGroup {
    return lhs |>> [rhs.__asNode()]
}

@discardableResult public func |>>(lhs: MortarView, rhs: [_MortarVFLNode]) -> MortarGroup {
    let capture = _MortarVFLListCapture(axis: .horizontal, list: rhs, trailingView: lhs)
    capture.setLeadingView(lhs)
    return try! capture.toGroup()
}

@discardableResult public func ||>>(lhs: MortarView, rhs: _MortarVFLNodable) -> MortarGroup {
    return lhs ||>> [rhs.__asNode()]
}

@discardableResult public func ||>>(lhs: MortarView, rhs: [MortarView]) -> MortarGroup {
    return lhs ||>> [rhs.__asNode()]
}

@discardableResult public func ||>>(lhs: MortarView, rhs: [_MortarVFLNode]) -> MortarGroup {
    var accum = rhs
    accum.insert(kMortarDefaultVFLPaddingNode, at: 0)
    accum.append(kMortarDefaultVFLPaddingNode)
    let capture = _MortarVFLListCapture(axis: .horizontal, list: accum, trailingView: lhs)
    capture.setLeadingView(lhs)
    return try! capture.toGroup()
}

// Vertical

@discardableResult public func |^(lhs: MortarView, rhs: _MortarVFLListCapture) -> MortarGroup {
    if rhs.axis != .vertical {
        NSException(name: NSExceptionName(rawValue: "Mortar VFL Operator Error"),
                  reason: "Mismatched VFL axis operators (e.g. |> with ^|)",
                userInfo: nil).raise()
    }
    rhs.setLeadingView(lhs)
    return try! rhs.toGroup()
}

@discardableResult public func |^(lhs: MortarView, rhs: _MortarVFLNodable) -> MortarGroup {
    return lhs |^ [rhs.__asNode()]
}

@discardableResult public func |^(lhs: MortarView, rhs: [MortarView]) -> MortarGroup {
    return lhs |^ [rhs.__asNode()]
}

@discardableResult public func |^(lhs: MortarView, rhs: [_MortarVFLNode]) -> MortarGroup {
    return lhs |^ _MortarVFLListCapture(axis: .vertical, list: rhs, trailingView: nil)
}

@discardableResult public func |^(lhs: MortarAttribute, rhs: _MortarVFLListCapture) -> MortarGroup {
    if rhs.axis != .vertical {
        NSException(name: NSExceptionName(rawValue: "Mortar VFL Operator Error"),
                  reason: "Mismatched VFL axis operators (e.g. |> with ^|)",
                userInfo: nil).raise()
    }
    rhs.setLeadingAttr(lhs)
    return try! rhs.toGroup()
}

@discardableResult public func |^(lhs: MortarAttribute, rhs: _MortarVFLNodable) -> MortarGroup {
    return lhs |^ [rhs.__asNode()]
}

@discardableResult public func |^(lhs: MortarAttribute, rhs: [MortarView]) -> MortarGroup {
    return lhs |^ [rhs.__asNode()]
}

@discardableResult public func |^(lhs: MortarAttribute, rhs: [_MortarVFLNode]) -> MortarGroup {
    return lhs |^ _MortarVFLListCapture(axis: .vertical, list: rhs, trailingView: nil)
}

@discardableResult public func ||^(lhs: MortarView, rhs: _MortarVFLListCapture) -> MortarGroup {
    if rhs.axis != .vertical {
        NSException(name: NSExceptionName(rawValue: "Mortar VFL Operator Error"),
                  reason: "Mismatched VFL axis operators (e.g. |> with ^|)",
                userInfo: nil).raise()
    }
    rhs.list.insert(kMortarDefaultVFLPaddingNode, at: 0)
    rhs.setLeadingView(lhs)
    return try! rhs.toGroup()
}

@discardableResult public func ||^(lhs: MortarView, rhs: _MortarVFLNodable) -> MortarGroup {
    return lhs ||^ [rhs.__asNode()]
}

@discardableResult public func ||^(lhs: MortarView, rhs: [MortarView]) -> MortarGroup {
    return lhs ||^ [rhs.__asNode()]
}

@discardableResult public func ||^(lhs: MortarView, rhs: [_MortarVFLNode]) -> MortarGroup {
    return lhs ||^ _MortarVFLListCapture(axis: .vertical, list: rhs, trailingView: nil)
}

@discardableResult public func ||^(lhs: MortarAttribute, rhs: _MortarVFLListCapture) -> MortarGroup {
    if rhs.axis != .vertical {
        NSException(name: NSExceptionName(rawValue: "Mortar VFL Operator Error"),
                  reason: "Mismatched VFL axis operators (e.g. |> with ^|)",
                userInfo: nil).raise()
    }
    rhs.list.insert(kMortarDefaultVFLPaddingNode, at: 0)
    rhs.setLeadingAttr(lhs)
    return try! rhs.toGroup()
}

@discardableResult public func ||^(lhs: MortarAttribute, rhs: _MortarVFLNodable) -> MortarGroup {
    return lhs ||^ [rhs.__asNode()]
}

@discardableResult public func ||^(lhs: MortarAttribute, rhs: [MortarView]) -> MortarGroup {
    return lhs ||^ [rhs.__asNode()]
}

@discardableResult public func ||^(lhs: MortarAttribute, rhs: [_MortarVFLNode]) -> MortarGroup {
    return lhs ||^ _MortarVFLListCapture(axis: .vertical, list: rhs, trailingView: nil)
}


@discardableResult public func |^^(lhs: MortarView, rhs: _MortarVFLNodable) -> MortarGroup {
    return lhs |^^ [rhs.__asNode()]
}

@discardableResult public func |^^(lhs: MortarView, rhs: [MortarView]) -> MortarGroup {
    return lhs |^^ [rhs.__asNode()]
}

@discardableResult public func |^^(lhs: MortarView, rhs: [_MortarVFLNode]) -> MortarGroup {
    let capture = _MortarVFLListCapture(axis: .vertical, list: rhs, trailingView: lhs)
    capture.setLeadingView(lhs)
    return try! capture.toGroup()
}

@discardableResult public func ||^^(lhs: MortarView, rhs: _MortarVFLNodable) -> MortarGroup {
    return lhs ||^^ [rhs.__asNode()]
}

@discardableResult public func ||^^(lhs: MortarView, rhs: [MortarView]) -> MortarGroup {
    return lhs ||^^ [rhs.__asNode()]
}

@discardableResult public func ||^^(lhs: MortarView, rhs: [_MortarVFLNode]) -> MortarGroup {
    var accum = rhs
    accum.insert(kMortarDefaultVFLPaddingNode, at: 0)
    accum.append(kMortarDefaultVFLPaddingNode)
    let capture = _MortarVFLListCapture(axis: .vertical, list: accum, trailingView: lhs)
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
        // Accumulate the constraints
        var result: MortarGroup = MortarGroup()
        
        // Tracks nodes by their view
        var nodeForView: [ObjectIdentifier: _MortarVFLNode] = [:]
        
        // There must be at least one weight-based node
        var weightNodeCount: Int = 0
        
        // There must be at least one view-based node
        var hasViewNode: Bool = false
        
        // This is the fallback spacing parent if closures are controller attributes
        var fallbackParent: MortarView? = nil
        
        for node in self.list {
            if node.sizingNode.sizingType == .weight {
                weightNodeCount += 1
            }
            
            if node.views.count > 0 {
                hasViewNode = true
                fallbackParent = node.views[0]
                for view in node.views {
                    guard nodeForView[ObjectIdentifier(view)] == nil else {
                        try! raise("The same view cannot appear multiple times in the VFL list")
                        return []
                    }
                    nodeForView[ObjectIdentifier(view)] = node
                }
            }
        }
        
        guard hasViewNode else {
            try! raise("You must have at least one view in the VFL list")
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
        
        // Ensure no weight nodes if missing trailing capture
        if (trailingAttr == nil || leadingAttr == nil) && weightNodeCount > 0 {
            try! raise("You may not use any weighted nodes without both leading and trailing capture operators")
            return []
        }
        
        // Ensure that unbounded lists are not capped with fixed padding
        if trailingAttr == nil && self.list[self.list.count - 1].views.count == 0 {
            try! raise("A VFL statement without a trailing closure may not end in non-view padding.")
            return []
        }
        
        if leadingAttr == nil && self.list[0].views.count == 0 {
            try! raise("A VFL statement without a leading closure may not begin with non-view padding.")
            return []
        }
        
        // Ensure sandwich attributes are valid
        if let suitableVFLAxis = leadingAttr?.attribute?.suitableVFLAxis {
            guard suitableVFLAxis == self.axis else {
                try! raise("Your leading attribute is not appropriate for axis: \(axis)")
                return []
            }
        }
        
        if let suitableVFLAxis = trailingAttr?.attribute?.suitableVFLAxis {
            guard suitableVFLAxis == self.axis else {
                try! raise("Your trailing attribute is not appropriate for axis: \(axis)")
                return []
            }
        }
        
        // ---- We should have done all prep; begin operation  ----
        
        // Previous keeps track of our "last" node state so that we can
        // link into it
        var previousTrailing:   MortarAttribute? = leadingAttr
        var previousFixed:      CGFloat          = 0
        
        // We don't explicitly size the first weighted node
        // so that there is some flexibility
        var firstWeightedNode: _MortarVFLNode? = nil
        var firstWeightedView: MortarView? = nil

        for node in self.list {
            guard let sizingFloat = node.sizingNode.floatable?.m_cgfloatValue() else {
                try! raise("Internal consistency error: vfl node has no floatable value during processing")
                return []
            }
            
            // First off, check for fixed size padding.  If it's true
            // we know that we cannot be adjacent to another, so we
            // assign it to the previousFixed
            if node.isFixedSizedPadding {
                previousFixed = sizingFloat
                continue
            }
            
            // If we're not fixed spacing, it must be view-based.
            let currentView: MortarView = (node.views.count > 0) ? node.views[0] : mGhostView(in: leadingView ?? trailingView ?? fallbackParent)
            
            // link backwards
            if let previousTrailing = previousTrailing {
                result.append( currentView.vflLeadingAttributeFor(axis: axis) |=| previousTrailing + previousFixed )
            }
            
            // width
            switch node.sizingNode.sizingType {
            case .intrinsic: break
            case .equals:
                result.append( currentView.vflSizingAttributeFor(axis: axis) |=| sizingFloat )
                
            case .weight:
                if let fWeightedView = firstWeightedView,
                   let fWeight       = firstWeightedNode?.sizingNode.floatable?.m_cgfloatValue() {
                    result.append( currentView.vflSizingAttributeFor(axis: axis) |=| fWeightedView.vflSizingAttributeFor(axis: axis) * (sizingFloat / fWeight) )
                } else {
                    // Set and skip the first weighted node for flexibility
                    firstWeightedNode = node
                    firstWeightedView = currentView
                }
            }
            
            // If we had more views in the array, match 'em
            if node.views.count > 1 {
                for idx in 1 ..< node.views.count {
                    node.views[idx].vflBondingAttributeFor(axis: axis) |=| currentView
                }
            }
            
            // Adjust previous values for next node
            previousTrailing = currentView.vflTrailingAttributeFor(axis: axis)
            previousFixed    = 0
        }
        
        // Link final previous up to trailing bounds
        if let trailingAttr = self.trailingAttr,
           let previousTrailing = previousTrailing {
            result.append( previousTrailing |=| trailingAttr - previousFixed )
        }
        
        return result
    }
    
}

// MARK: - MortarView helpers for linking VFL nodes

private extension MortarView {
    func vflLeadingAttributeFor(axis: MortarAxis) -> MortarAttribute {
        switch axis {
        case .horizontal:   return self.m_left
        case .vertical:     return self.m_top
        }
    }
    
    func vflTrailingAttributeFor(axis: MortarAxis) -> MortarAttribute {
        switch axis {
        case .horizontal:   return self.m_right
        case .vertical:     return self.m_bottom
        }
    }
    
    func vflSizingAttributeFor(axis: MortarAxis) -> MortarAttribute {
        switch axis {
        case .horizontal:   return self.m_width
        case .vertical:     return self.m_height
        }
    }
    
    func vflBondingAttributeFor(axis: MortarAxis) -> MortarAttribute {
        switch axis {
        case .horizontal:   return self.m_sides
        case .vertical:     return self.m_caps
        }
    }
}

// MARK: - Axis/Attribute verification

private extension MortarLayoutAttribute {
    var suitableVFLAxis: MortarAxis? {
        #if os(iOS) || os(tvOS)
            switch self {
            case .left:                     return .horizontal
            case .right:                    return .horizontal
            case .top:                      return .vertical
            case .bottom:                   return .vertical
            case .leading:                  return .horizontal
            case .trailing:                 return .horizontal
            case .centerX:                  return .horizontal
            case .centerY:                  return .vertical
            case .baseline:                 return .vertical
            case .firstBaseline:            return .vertical
            case .lastBaseline:             return .vertical
            case .leftMargin:               return .horizontal
            case .rightMargin:              return .horizontal
            case .topMargin:                return .vertical
            case .bottomMargin:             return .vertical
            case .leadingMargin:            return .horizontal
            case .trailingMargin:           return .horizontal
            case .centerXWithinMargins:     return .horizontal
            case .centerYWithinMargins:     return .vertical
            default:                        return nil
            }
        #else
            switch self {
            case .left:                     return .horizontal
            case .right:                    return .horizontal
            case .top:                      return .vertical
            case .bottom:                   return .vertical
            case .leading:                  return .horizontal
            case .trailing:                 return .horizontal
            case .centerX:                  return .horizontal
            case .centerY:                  return .vertical
            case .baseline:                 return .vertical
            default:                        return nil
            }
        #endif
    }
}

// MARK: - ViewController visible region

#if os(iOS)
public extension UIViewController {
    
    @nonobjc private static let kVisibleRegionGhostTag: Int = Int.min + 10
    
    /// Creates a _MortarVFLGhostView that is sized between the
    /// view controller's guide anchors.
    /// Will reuse the existing one if it exists, based on tag lookup
    public var m_visibleRegion: MortarView {
        for view in self.view.subviews {
            if view.tag != UIViewController.kVisibleRegionGhostTag {
                continue
            }
            
            if let v = view as? _MortarVFLGhostView {
                return v
            } else {
                try! raise("You cannot use m_visibleRegion unless you reserve the tag \(UIViewController.kVisibleRegionGhostTag) for its use")
            }
        }
        
        // Create it
        let ghost = mGhostView(in: self.view)
        ghost.tag = UIViewController.kVisibleRegionGhostTag
        ghost.m_sides  |=| self.view
        ghost.m_top    |=| self.m_topLayoutGuideBottom
        ghost.m_bottom |=| self.m_bottomLayoutGuideTop
        return ghost
    }
}
#endif
