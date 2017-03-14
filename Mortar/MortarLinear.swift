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

private var keyH = "mortar_dir_options_keyH"
private var keyV = "mortar_dir_options_keyV"
private var keyAny = "mortar_dir_options_keyAny"

// MARK: - Classes

// a trivial subclass of UIView that exposes concise convenience initializers for the common use case of empty/invisible spacer views
public class MortarPadView: MortarView {
    public convenience init(wt: CGFloat, min: CGFloat? = nil, max: CGFloat? = nil, axis: UILayoutConstraintAxis? = nil) {
        self.init(frame: CGRect.zero)
        m_linear(wt: wt, min: min, max: max, axis: axis)

    }

    public convenience init(c: CGFloat, axis: UILayoutConstraintAxis? = nil) {
        self.init(frame: CGRect.zero)
        m_linear(c: c, axis: axis)
    }
}

// Sizing properties for an axis.
class MortarLinearLayoutSizingOptions: NSObject {
    init(c: CGFloat) {
        self.constant = c
    }
    init(wt: CGFloat, min: CGFloat? = nil, max: CGFloat? = nil) {
        self.weight = wt
        self.min = min
        self.max = max
    }
    var constant: CGFloat?  = nil
    var weight: CGFloat?  = nil
    var min: CGFloat?  = nil
    var max: CGFloat?  = nil
}

// MARK: - Protocol

// Protocol to opt into linear layouts.  Currently only views do, but UILayoutGuides ought to be doable as well
protocol MortarLinearLayoutSizeable {
    func m_getLinearOptions(_ axis: UILayoutConstraintAxis?) -> MortarLinearLayoutSizingOptions?

    @discardableResult func m_linear(c: CGFloat, axis: UILayoutConstraintAxis?) -> Self
    @discardableResult func m_linear(wt: CGFloat, min: CGFloat?, max: CGFloat?, axis: UILayoutConstraintAxis?) -> Self
}

// MARK: - MortarView Protocol conformance

// Make Views conform to the linear layout protocol. This is done with objc_setAssociatedObject which is a tad regretable, but
// it's one of the only ways to effectively tack on "metada" to arbitrary view so they can all retroactively get this functionality
extension MortarView: MortarLinearLayoutSizeable {
    @discardableResult
    public func m_linear(wt: CGFloat, min: CGFloat? = nil, max: CGFloat? = nil, axis: UILayoutConstraintAxis? = nil) -> Self {
        mortar_associateLinearOptions(options: MortarLinearLayoutSizingOptions(wt: wt, min: min, max: max), with: self, axis: axis)
        return self
    }

    @discardableResult
    public func m_linear(c: CGFloat, axis: UILayoutConstraintAxis? = nil) -> Self {
        mortar_associateLinearOptions(options: MortarLinearLayoutSizingOptions(c: c), with: self, axis: axis)
        return self
    }

    func m_getLinearOptions(_ axis: UILayoutConstraintAxis? = nil) -> MortarLinearLayoutSizingOptions? {
        let get = { mortar_getLinearOptionsAssociatedWith(self, axis: $0) }
        return (axis == .horizontal) ? (get(.horizontal) ?? get(nil)) :
               (axis == .vertical)   ? (get(.vertical) ?? get(nil)) :
                                       (get(nil) ?? get(.vertical) ?? get(.horizontal))
    }
}

// MARK: - Constraint Logic

/// constrain views in views edge to edge in axis optionally between the edges of inside or to/from.  also constrain size of any SpacerViews in views
internal func linearConstrain(_ views: [MortarView], axis: UILayoutConstraintAxis = .vertical, inside: MortarView? = nil, from: MortarAttribute? = nil, to: MortarAttribute? = nil, debug: Bool = false)
    -> [MortarConstraint] {
        guard views.count > 0 else { return [] }
        let getEdges: (MortarView) -> [MortarAttribute] = (axis == .horizontal) ? {[$0.m_left, $0.m_right]} : {[$0.m_top, $0.m_bottom]}

        if let (first, last) = inside.map(getEdges)?.mortar_tuple2() {
            return linearConstrain(views, axis:axis, from:first, to:last, debug:debug)
        }

        let spacers = views.filter({ $0.m_getLinearOptions(axis) != nil })
                           .sorted(by: { $0.m_getLinearOptions(axis)?.weight ?? 0 > $1.m_getLinearOptions(axis)?.weight ?? 0 })

        let sizeAttribute: MortarLayoutAttribute = (axis == .horizontal) ? .width : .height
        var constraints = Array(spacers.map({ constrainConstants(view: $0, attribute: sizeAttribute, axis:axis) }).joined())

        // constrain weighted view sizes relative to size of largest
        if let (head, tail) = spacers.mortar_headTail,
            let maxWeight = head.m_getLinearOptions(axis)?.weight, tail.count > 0 {
            spacers.forEach { $0.m_getLinearOptions(axis)?.weight = $0.m_getLinearOptions(axis)?.weight.map {$0 / maxWeight} }   //scale all weights into 0.0 to 1.0

            tail.forEach { spacer in
                if let weight = spacer.m_getLinearOptions(axis)?.weight {
                    constraints += [MortarAttribute(item: spacer, attribute: sizeAttribute) |=| MortarAttribute(item: head, attribute: sizeAttribute) * weight ! priorityForWeight(weight)]
                }
            }
        }

        // pin all the adjacent edges together
        var edges = Array(views.map(getEdges).joined())
        if let from = from {
            edges.insert(from, at: 1)  // special case workaround.
            // We insert at index 1 so we later have someView.m_top |=| fromView.m_top which is the order we'd naturally write it. This is is necessary because the |=| sets
            // .translatesAutoresizingMaskIntoConstraints on the left side and from's view is often the superview of the views we're trying to constrain which we shouldn't be
            // touching its .translatesAutoresizingMaskIntoConstraints.
        } else {
            edges.remove(at: 0)
        }
        if let to = to {
            edges.insert(to, at: edges.count)
        } else {
            edges.remove(at: edges.count-1)
        }
        edges.mortar_chunk(2).forEach { edgePairArray in
            if let (a, b)  = edgePairArray.mortar_tuple2() {
                constraints += [ a |=| b ]
            }
        }
        return constraints
}

// constrain height/width to fixed, min, and/or max values
fileprivate func constrainConstants(view: MortarView ,  attribute: MortarLayoutAttribute, axis: UILayoutConstraintAxis) -> [MortarConstraint] {
    let lhs = MortarAttribute(item: view, attribute: attribute)
    return [view.m_getLinearOptions(axis)?.constant.map { lhs |=| $0 ! .high },
            view.m_getLinearOptions(axis)?.min.map {  lhs |>| $0 ! .high },
            view.m_getLinearOptions(axis)?.max.map { lhs |<| $0 ! .high }
        ].flatMap { $0 }
}

// Give the weighted views slightly lower priorities than current.
// Rarely matters, but if it all doesn't fit, then we want the weighted constraints to break before the const/min/max ones, smallest to largest
fileprivate func priorityForWeight(_ weight: CGFloat) -> MortarAliasLayoutPriority {
    let upper = MortarDefault.priority.current() - 1
    let lower = max(upper - 100 , 0)
    let range = upper - lower
    return lower + Float(weight) * range
}

// MARK: - Utility

// associate an MortarLinearLayoutSizingOptions with the given object and axis
internal func mortar_associateLinearOptions(options: MortarLinearLayoutSizingOptions, with obj: Any, axis: UILayoutConstraintAxis?) {
    switch axis {
    case .horizontal?: objc_setAssociatedObject(obj, &keyH, options, .OBJC_ASSOCIATION_RETAIN)
    case .vertical?:  objc_setAssociatedObject(obj, &keyV, options, .OBJC_ASSOCIATION_RETAIN)
    default: objc_setAssociatedObject(obj, &keyAny, options, .OBJC_ASSOCIATION_RETAIN)
    }
}

// get the MortarLinearLayoutSizingOptions associated with the given object and axis
internal func mortar_getLinearOptionsAssociatedWith(_ obj: Any, axis: UILayoutConstraintAxis?) -> MortarLinearLayoutSizingOptions? {
    switch axis {
    case .horizontal?: return objc_getAssociatedObject(obj, &keyH) as? MortarLinearLayoutSizingOptions
    case .vertical?:  return objc_getAssociatedObject(obj, &keyV) as? MortarLinearLayoutSizingOptions
    default: return objc_getAssociatedObject(obj, &keyAny) as? MortarLinearLayoutSizingOptions
    }
}

// A few utility methods used in the above
fileprivate extension Array {

    // convert an array into an arra of arrays where each sub array is the next n elements.  ex: [1,2,3,4,5,6].chunk(2) -> [[1,2][3,4][5,6]]
    func mortar_chunk(_ n: Int) -> [[Element]] {
        var res: [[Element]] = []
        var i = 0
        var j: Int
        while i < self.endIndex {
            j = self.index(i, offsetBy: n, limitedBy: self.endIndex) ?? self.endIndex
            res.append(Array(self[i..<j]))
            i = j
        }
        return res
    }

    // destructuring into head:tail
    var mortar_headTail: (head: Element, tail: [Element])? {
        return (count > 0) ? (self[0], Array(self[1..<count])) : nil
    }

    // converts a 2 element array to a 2 tuple
    func mortar_tuple2() -> (Element, Element)? {
        return self.count == 2 ? (self[0], self[1]) : nil
    }
}
