//
//  ViewController.swift
//  Copyright © 2025 Jason Fieldman.
//

import Mortar

class ViewController: UIViewController {
    let testProp = MutableProperty<Int>(0)
    let boolProp = MutableProperty<Bool>(false)

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
                // Layout
                $0.anchors.bottom == parent.safeAreaLayoutGuide.anchors.bottom - 40
                $0.anchors.sides == parent.anchors.sides

                // Configuration
                $0.alignment = .center
                $0.backgroundColor = .white

                // Subviews
                UILabel {
                    $0.text = "Hello, World!"
                }

                UILabel {
                    $0.bind(\.text) <~ testProp.map { "Test \($0)" }
                }

                UILabel {
                    $0.sink(testProp) { $0.text = "Test \($1)" }
                }

                UILabel {
                    $0.sink(boolProp) { $0.text = "boolprop is \($1)" }
                }

                UILabel {
                    $0.bind(\.text) <~ boolProp.map { "boolprop is \($0)" }
                }

                UISwitch {
                    boolProp <~ $0.events(.valueChanged).map(\.isOn)
                }
            }
        }
        view.backgroundColor = .red

        for t in 1 ..< 100 {
            DispatchQueue.global().asyncAfter(deadline: .now() + TimeInterval(t)) {
                self.testProp.value = t
            }
        }
    }
}
