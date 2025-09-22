//
//  MortarScrollView.swift
//  Copyright © 2025 Jason Fieldman.
//

#if os(iOS) || os(tvOS)

import UIKit

public extension UIScrollView {
    func installReactiveKeyboardInsets() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(_handleKeyboardShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(_handleKeyboardHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc func _handleKeyboardShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let animationCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else {
            return
        }

        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        let animationOptions = UIView.AnimationOptions(rawValue: animationCurve << 16)
        UIView.animate(withDuration: animationDuration, delay: 0, options: animationOptions) {
            self.contentInset = insets
            self.scrollIndicatorInsets = insets
        }
    }

    @objc func _handleKeyboardHide(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let animationCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else { return }

        let animationOptions = UIView.AnimationOptions(rawValue: animationCurve << 16)
        UIView.animate(withDuration: animationDuration, delay: 0, options: animationOptions) {
            self.contentInset = .zero
            self.scrollIndicatorInsets = .zero
        }
    }
}

#endif
