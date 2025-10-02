//
//  ManagedTableViewDelegation.swift
//  Copyright © 2025 Jason Fieldman.
//

#if os(iOS) || os(tvOS)

import UIKit

public extension ManagedTableView {
    /// Configures the gesture recognizer's delegate with a block.
    ///
    /// - Parameter configureBlock: A closure that configures the gesture recognizer delegate.
    /// - Returns: The configured gesture recognizer instance.
    func scrollDelegation(_ configureBlock: (_ManagedTableViewScrollDelegateHandler) -> Void) {
        configureBlock(scrollDelegateHandler)
    }
}

public final class _ManagedTableViewScrollDelegateHandler: NSObject {
    /// Called when the user scrolls the content view.
    public var didScroll: ((ManagedTableView) -> Void)?

    /// Called when the user scrolls to the top of the content view.
    public var didScrollToTop: ((ManagedTableView) -> Void)?

    /// Asks the delegate if the scroll view should scroll to the top.
    public var shouldScrollToTop: ((ManagedTableView) -> Bool)?

    /// Called when the user finishes zooming.
    public var didZoom: ((ManagedTableView) -> Void)?

    /// Called when the user begins zooming.
    public var willBeginZooming: ((ManagedTableView, UIView?) -> Void)?

    /// Called when the user finishes zooming.
    public var didEndZooming: ((ManagedTableView, UIView?, CGFloat) -> Void)?

    /// Called when the user begins dragging.
    public var willBeginDragging: ((ManagedTableView) -> Void)?

    /// Called when the user ends dragging.
    public var willEndDragging: ((ManagedTableView, CGPoint, UnsafeMutablePointer<CGPoint>) -> Void)?

    /// Called when the user ends dragging.
    public var didEndDragging: ((ManagedTableView, Bool) -> Void)?

    /// Called when the user begins decelerating.
    public var willBeginDecelerating: ((ManagedTableView) -> Void)?

    /// Called when the user ends decelerating.
    public var didEndDecelerating: ((ManagedTableView) -> Void)?

    /// Called when the scroll view ends scrolling animation.
    public var didEndScrollingAnimation: ((ManagedTableView) -> Void)?

    /// Called when the scroll view's adjusted content inset changes.
    public var didChangeAdjustedContentInset: ((ManagedTableView) -> Void)?
}

extension ManagedTableView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollDelegateHandler.didScroll?(scrollView as! ManagedTableView)
    }

    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        scrollDelegateHandler.didScrollToTop?(scrollView as! ManagedTableView)
    }

    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        scrollDelegateHandler.shouldScrollToTop?(scrollView as! ManagedTableView) ?? true
    }

    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollDelegateHandler.willBeginZooming?(scrollView as! ManagedTableView, view)
    }

    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollDelegateHandler.didZoom?(scrollView as! ManagedTableView)
    }

    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollDelegateHandler.didEndZooming?(scrollView as! ManagedTableView, view, scale)
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollDelegateHandler.willBeginDragging?(scrollView as! ManagedTableView)
    }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollDelegateHandler.willEndDragging?(scrollView as! ManagedTableView, velocity, targetContentOffset)
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollDelegateHandler.didEndDragging?(scrollView as! ManagedTableView, decelerate)
    }

    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        scrollDelegateHandler.willBeginDecelerating?(scrollView as! ManagedTableView)
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollDelegateHandler.didEndDecelerating?(scrollView as! ManagedTableView)
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollDelegateHandler.didEndScrollingAnimation?(scrollView as! ManagedTableView)
    }

    public func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        scrollDelegateHandler.didChangeAdjustedContentInset?(scrollView as! ManagedTableView)
    }
}

#endif
