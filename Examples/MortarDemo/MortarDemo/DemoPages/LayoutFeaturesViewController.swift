//
//  LayoutFeaturesViewController.swift
//  Copyright © 2016 Jason Fieldman.
//

import Mortar

class LayoutFeaturesViewController: UIViewController {
    override func loadView() {
        view = UIContainer { container in
            container.backgroundColor = .darkGray

            // Basic layout features against named parent
            UIView {
                $0.backgroundColor = .blue
                $0.layout.top == container.layout.top
                $0.layout.leading == container.layout.leading
                $0.layout.size == CGSize(width: 100, height: 100)
            }

            // Use anonymous parent layout reference
            UIView {
                $0.backgroundColor = .red
                $0.layout.topTrailing == $0.parentLayout.topTrailing
                $0.layout.size == CGSize(width: 100, height: 100)

                // For use in the example below
                $0.layoutReferenceId = "redSquare"
            }

            // Use layout references to bind layout against
            // any other view in the hierarchy
            UIView {
                $0.backgroundColor = .yellow
                $0.layout.bottomTrailing == $0.referencedLayout("redSquare").bottomTrailing
                $0.layout.size == CGSize(width: 25, height: 25)
            }

            // Use a named UIView as the right side if the attribute
            // is the same
            UIView {
                $0.backgroundColor = .green
                $0.layout.bottomLeading == container // don't need to use layout anchors
                $0.layout.size == $0.referencedLayout("redSquare").size
            }

            // Apply operators to layout to adjust constraint constants
            UIView {
                $0.backgroundColor = .orange
                $0.layout.bottom == $0.parentLayout.bottom - 40
                $0.layout.trailing == $0.parentLayout.trailing - 40
                $0.layout.size == $0.referencedLayout("redSquare").size / 2
            }

            // Use inequality operators for less/greater than constraints
            UIView {
                $0.backgroundColor = .purple
                $0.layout.size >= $0.referencedLayout("redSquare").size
                $0.layout.size <= CGSize(width: 200, height: 200)
                $0.layout.top == $0.referencedLayout("redSquare").bottom + 20
                $0.layout.trailing == $0.parentLayout.trailing
            }

            // Use layout guides as well
            UIView {
                $0.backgroundColor = .brown
                $0.layout.bottom == container.safeAreaLayoutGuide.layout.bottom
                $0.layout.leading == $0.parentLayout.leading
                $0.layout.size == CGSize(width: 300, height: 20)
            }
        }
    }
}
