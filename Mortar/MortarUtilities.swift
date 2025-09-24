//
//  MortarUtilities.swift
//  Copyright © 2025 Jason Fieldman.
//

import UIKit

public extension UIResponder {
    /// Walks up the responder chain to the find the first UIViewController
    /// containing the receiver.
    func containingViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            responder = nextResponder
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
