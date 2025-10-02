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
    public var didScroll: ((UIScrollView) -> Void)?

    /// Called when the user scrolls to the top of the content view.
    public var didScrollToTop: ((UIScrollView) -> Void)?

    /// Asks the delegate if the scroll view should scroll to the top.
    public var shouldScrollToTop: ((UIScrollView) -> Bool)?

    /// Called when the user finishes zooming.
    public var didZoom: ((UIScrollView) -> Void)?

    /// Called when the user begins zooming.
    public var willBeginZooming: ((UIScrollView, UIView?) -> Void)?

    /// Called when the user finishes zooming.
    public var didEndZooming: ((UIScrollView, UIView?, CGFloat) -> Void)?

    /// Called when the user begins dragging.
    public var willBeginDragging: ((UIScrollView) -> Void)?

    /// Called when the user ends dragging.
    public var willEndDragging: ((UIScrollView, CGPoint, UnsafeMutablePointer<CGPoint>) -> Void)?

    /// Called when the user ends dragging.
    public var didEndDragging: ((UIScrollView, Bool) -> Void)?

    /// Called when the user begins decelerating.
    public var willBeginDecelerating: ((UIScrollView) -> Void)?

    /// Called when the user ends decelerating.
    public var didEndDecelerating: ((UIScrollView) -> Void)?

    /// Called when the scroll view ends scrolling animation.
    public var didEndScrollingAnimation: ((UIScrollView) -> Void)?

    /// Called when the scroll view's adjusted content inset changes.
    public var didChangeAdjustedContentInset: ((UIScrollView) -> Void)?
}

extension ManagedTableView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollDelegateHandler.didScroll?(scrollView)
    }

    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        scrollDelegateHandler.didScrollToTop?(scrollView)
    }

    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        scrollDelegateHandler.shouldScrollToTop?(scrollView) ?? true
    }

    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollDelegateHandler.willBeginZooming?(scrollView, view)
    }

    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollDelegateHandler.didZoom?(scrollView)
    }

    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollDelegateHandler.didEndZooming?(scrollView, view, scale)
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollDelegateHandler.willBeginDragging?(scrollView)
    }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollDelegateHandler.willEndDragging?(scrollView, velocity, targetContentOffset)
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollDelegateHandler.didEndDragging?(scrollView, decelerate)
    }

    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        scrollDelegateHandler.willBeginDecelerating?(scrollView)
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollDelegateHandler.didEndDecelerating?(scrollView)
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollDelegateHandler.didEndScrollingAnimation?(scrollView)
    }

    public func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        scrollDelegateHandler.didChangeAdjustedContentInset?(scrollView)
    }
}

#endif
