//
//  LayoutFeaturesViewController.swift
//  Copyright © 2025 Jason Fieldman.
//

import Mortar

class LayoutFeaturesViewController: UIViewController {
    override func loadView() {
        view = UIContainer {
            $0.backgroundColor = .darkGray

            VStackView {
                $0.backgroundColor = .lightGray
                $0.layout.leading == $0.parentLayout.leadingMargin
                $0.layout.trailing == $0.parentLayout.trailingMargin
                $0.layout.centerY == $0.parentLayout.centerY

                UILabel {
                    $0.layout.height == 44
                    $0.text = "Hello, World!"
                    $0.textColor = .red
                    $0.textAlignment = .center
                }

                UIButton(type: .roundedRect) {
                    $0.layoutReferenceId = "button"
                    $0.setTitle("Button", for: .normal)
                    $0.handleEvents(.touchUpInside) { _ in NSLog("touched") }
                }
            }
        }
    }
}
