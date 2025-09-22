//
//  BasicManagedTableView.swift
//  Copyright © 2025 Jason Fieldman.
//

import CombineEx
import Mortar

/// Each row in a ManagedTableView is a pair of model/cell implementations
/// that refer to eachother with associated types.
///
/// The model is an immutable struct, which can be composed in background
/// threads from other reactive sources.
///
/// The models are composed into sections, which are reactively fed into
/// the ManagedTableView. Interally, the table dequeues associated cell
/// types and feeds the corresponding model into the cell.
///
/// This example shows some very basic model/cell construction.
class BasicManagedTableViewController: UIViewController {
    override func loadView() {
        view = UIContainer {
            $0.backgroundColor = .white

            ManagedTableView {
                $0.layout.edges == $0.parentLayout.edges
                $0.bind(\.sections) <~ Property(value: [self.makeSection()])
            }
        }
    }

    /// Constructing the section models is usually more complex than you
    /// want in the view hierarchy code. Feel free to create a separate
    /// builder function, like this. Typically you would supply reactive
    /// inputs.
    private func makeSection() -> ManagedTableViewSection {
        // Sections/row models can all be created from structs
        ManagedTableViewSection(
            rows: [
                SimpleTextRowCell.Model(text: "Simple row, disclosure false", showDisclosure: false),
                SimpleTextRowCell.Model(text: "Simple row, disclosure true", showDisclosure: true),

                // You can freely mix and match models inside the rows array

                AlertTextRowCell.Model(text: "Tap to alert") { [weak self] in
                    let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: .alert)
                    alert.addAction(.init(title: "OK", style: .default))
                    self?.present(alert, animated: true)
                },
            ]
        )
    }
}

// MARK: - Row Implementations

/// For managed cells, override the standard init method and configure
/// the `contentView` with your view hierarchy.
///
/// The `model` ivar is provided for you. It is an AnyPublisher<Model>
/// that will emit a new Model value each time the section input changes.
/// Note that this also crosses cell reuse - so the new model can represent
/// a completely different underlying element.
private final class SimpleTextRowCell: UITableViewCell, ManagedTableViewCell {
    /// Models can be simple structs; don't forget to declare conformity
    /// to `ManagedTableViewCellModel`
    struct Model: ManagedTableViewCellModel, ArbitrarilyIdentifiable {
        typealias Cell = SimpleTextRowCell

        let id: String = UUID().uuidString
        let text: String
        let showDisclosure: Bool
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.configure {
            UILabel {
                $0.layout.leading == $0.parentLayout.leadingMargin
                $0.layout.caps == $0.parentLayout.caps
                $0.layout.height >= 50
                $0.textColor = .darkGray

                // Note that because the model itself is a publisher, you will
                // often need to map it (instead of a simple `model.text` here)
                $0.bind(\.text) <~ model.map(\.text)
            }
        }

        // This is a standard UITableViewCell, so feel free to adjust other
        // aspects of its behavior as needed
        bind(\.accessoryType) <~ model.map { $0.showDisclosure ? .disclosureIndicator : .none }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private final class AlertTextRowCell: UITableViewCell, ManagedTableViewCell {
    struct Model: ManagedTableViewCellModel, ArbitrarilyIdentifiable {
        typealias Cell = AlertTextRowCell

        let id: String = UUID().uuidString
        let text: String
        let onSelect: (() -> Void)?
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        textLabel?.bind(\.text) <~ model.map(\.text)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
