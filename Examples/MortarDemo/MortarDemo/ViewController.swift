//
//  ViewController.swift
//  Copyright © 2025 Jason Fieldman.
//

import Mortar

class ViewController: UIViewController {
    let testProp = MutableProperty<Int>(0)
    let boolProp = MutableProperty<Bool>(false)

    let tableStrings = MutableProperty<[String]>(["Hello", "World"])

    let legacyLabel = {
        let label = UILabel()
        label.text = "Old Style"
        label.backgroundColor = .magenta
        return label
    }()

    override func loadView() {
        view = ZStackView { parent in
            ZStackView { child1 in
                child1.backgroundColor = .blue
                child1.layout.center == parent.layout.center
                child1.layout.size == CGSize(width: 100, height: 200)

                UIView { inner in
                    inner.backgroundColor = .yellow
                    inner.layout.topLeft == parent.layout.topLeft + CGPoint(x: 40, y: 80)
                    inner.layout.width == 100
                    inner.layout.height == 200
                }

                legacyLabel.configure {
                    $0.layout.centerX == parent.layout.centerX
                    $0.layout.bottom == child1.layout.top
                }
            }

            ManagedTableView {
                $0.backgroundColor = .green
                $0.layout.leading == parent.layout.leading
                $0.layout.size == CGSize(width: 150, height: 300)
                $0.layout.top == parent.layout.top + 300

                $0.sections <~ tableStrings.map { strings -> [ManagedTableViewSection] in
                    [
                        ManagedTableViewSection(
                            rows: strings.map {
                                SimpleRowCell.Model(text: $0)
                            }
                        ),
                    ]
                }
            }

            VStackView {
                // Layout
                $0.layout.bottom == parent.safeAreaLayoutGuide.layout.bottom - 40
                $0.layout.sides == parent.layout.sides

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
                    boolProp <~ $0.publishEvents(.valueChanged).map(\.isOn)

                    $0.handleEvents(.valueChanged) { [weak self] _ in
                        self?.tableStrings.modify { $0 = $0 + ["Toggled"] }
                    }
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

class SimpleRowCell: UITableViewCell, ManagedTableViewCell {
    struct Model: ManagedTableViewCellModel {
        typealias Cell = SimpleRowCell

        let text: String
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.configure { contentView in
            UILabel {
                $0.layout.edges == contentView.layout.edges
                $0.bind(\.text) <~ self.model.map(\.text)
            }
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
