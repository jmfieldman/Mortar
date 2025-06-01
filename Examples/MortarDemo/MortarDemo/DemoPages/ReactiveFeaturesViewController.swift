//
//  ReactiveFeaturesViewController.swift
//  Copyright © 2025 Jason Fieldman.
//

import CombineEx
import Mortar

/// Mortar is designed with CombineEx in mind for view state/handling.
class ReactiveFeaturesViewController: UIViewController {
    /// Putting underlying state/model in a separate object helps
    /// enforce unidirectional flow of information, and makes view
    /// controller state easier to unit test.
    private let model = ReactiveFeaturesViewControllerModel()

    override func loadView() {
        view = UIContainer { container in
            container.backgroundColor = .darkGray

            VStackView {
                $0.backgroundColor = .white
                $0.alignment = .fill
                $0.layout.sides == $0.parentLayout.sideMargins
                $0.layout.centerY == $0.parentLayout.centerY

                UISwitch {
                    // Many variations of `handleEvents` allow you to reactively
                    // handle typical UIControl actions. This example allows you to
                    // pass an input in an Action based on the transform block
                    $0.handleEvents(.valueChanged, model.toggleStateAction) { $0.isOn }
                }

                UILabel {
                    $0.layout.height == 44
                    // Bind is the preferred method to assign reactive properties
                    // to single-value keypaths.
                    $0.bind(\.text) <~ model.toggleState.map { "Toggle is \($0)" }
                }

                UILabel {
                    $0.layout.height == 44
                    $0.bind(\.text) <~ model.toggleCount.map { "Toggle change count: \($0)" }
                }
            }

            UIView {
                $0.backgroundColor = .orange
                $0.layout.size == CGSize(width: 40, height: 40)
                $0.layout.centerX == $0.parentLayout.centerX
                $0.layout.top == $0.parentLayout.top + 200

                // You can also sink publishers when you want to perform more
                // complex tasks on their value update.
                $0.sink(model.toggled) { square in
                    UIView.animate(
                        springDuration: 0.4,
                        bounce: 0.4,
                        initialSpringVelocity: 0,
                        delay: 0,
                        options: [],
                        animations: {
                            square.transform = CGAffineTransform(
                                translationX: CGFloat.random(in: -50 ... 50),
                                y: CGFloat.random(in: -50 ... 50)
                            )
                        }, completion: { _ in }
                    )
                }
            }
        }
    }
}

// MARK: - View Controller Model

private class ReactiveFeaturesViewControllerModel {
    // Public interface

    /// For UI hookup, consider exposing your work publishers as Actions, which
    /// ensures that the underlying work can only be run once in parallel. Each
    /// time the action is triggered, it will build the publisher from the
    /// block declared at initialization.
    private(set) lazy var toggleStateAction = Action<Bool, Void, Never> { [weak self] newValue in
        self?.toggleState(to: newValue) ?? .empty()
    }

    /// Expose internal MutableProperty instances as Property; this allows
    /// consumers to monitor state without the ability to modify it.
    private(set) lazy var toggleState = Property(mutableToggleState)
    private(set) lazy var toggleCount = Property(mutableToggleCount)
    private(set) lazy var toggled = toggleState.dropFirst().map { _ in }.eraseToAnyPublisher()

    // Private implementation

    private let mutableToggleState = MutableProperty<Bool>(false)
    private let mutableToggleCount = MutableProperty<Int>(0)

    /// This is an example of generating a deferred publisher that can perform some
    /// async work on each subscription.
    private func toggleState(to newValue: Bool) -> AnyDeferredPublisher<Void, Never> {
        DeferredFuture { [weak self] promise in
            self?.mutableToggleState.value = newValue
            self?.mutableToggleCount.modify { $0 += 1 }
            promise(.success(()))
        }.eraseToAnyDeferredPublisher()
    }
}
