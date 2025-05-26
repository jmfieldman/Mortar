//
//  ViewController.swift
//  Copyright © 2025 Jason Fieldman.
//

import Mortar

class ViewController: UIViewController {
    override func loadView() {
        view = ZStackView { parent in
            ZStackView { child1 in
                child1.backgroundColor = .blue
                child1.anchors.center == parent.anchors.center
                child1.size == CGSize(width: 100, height: 100)

                UIView { inner in
                    inner.backgroundColor = .yellow
                    inner.anchors.topLeft == parent.anchors.topLeft + CGPoint(x: 40, y: 80)
                    inner.size.width == 100
                    inner.size.height == 200
                }
            }

            VStackView {
                $0.alignment = .center
                $0.backgroundColor = .white
                $0.anchors.bottom == parent.anchors.bottom - 40
                $0.anchors.sides == parent.anchors.sides

                UILabel {
                    $0.text = "Hello, World!"
                }

                UILabel {
                    $0.text = "Line 2"
                }
            }
        }
        view.backgroundColor = .red
    }
}
