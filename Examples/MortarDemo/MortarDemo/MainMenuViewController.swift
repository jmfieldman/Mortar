//
//  MainMenuViewController.swift
//  Copyright © 2016 Jason Fieldman.
//

import Mortar

class MainMenuViewController: UIViewController {
    private let model = MainMenuViewControllerModel()

    override func loadView() {
        title = "Mortar Demo"

        // Main View
        view = UIContainer {
            ManagedTableView {
                $0.layout.edges == $0.parentLayout.edges

                $0.sections <~ Property<[ManagedTableViewSection]>.combineLatest(
                    model.demoScreens,
                    model.sortStarred,
                    model.starList
                ).map { [unowned self] demoScreens, sortStarred, starList -> [ManagedTableViewSection] in
                    return makeSections(
                        demoScreens: demoScreens,
                        sortStarred: sortStarred,
                        starList: starList
                    )
                }
            }
        }

        // Sort selector
        navigationItem.bind(\.rightBarButtonItems) <~ model
            .sortStarred.map { [unowned self] sortStarred in
                return [
                    UIBarButtonItem(
                        image: .init(systemName: sortStarred ? "star.fill" : "star"),
                        style: .plain,
                        target: model,
                        action: #selector(MainMenuViewControllerModel.toggleSortStarred)
                    ),
                ]
            }
    }

    private func makeSections(
        demoScreens: [DemoScreen],
        sortStarred: Bool,
        starList: Set<String>
    ) -> [ManagedTableViewSection] {
        if sortStarred {
            let starredScreens = demoScreens.filter { starList.contains($0.title) }
            let unstarredScreens = demoScreens.filter { !starList.contains($0.title) }

            return [
                ManagedTableViewSection(
                    rows: makeRows(demoScreens: starredScreens, starList: starList)
                ),
                ManagedTableViewSection(
                    rows: makeRows(demoScreens: unstarredScreens, starList: starList)
                ),
            ]
        } else {
            return [
                ManagedTableViewSection(
                    rows: makeRows(demoScreens: demoScreens, starList: starList)
                ),
            ]
        }
    }

    private func makeRows(demoScreens: [DemoScreen], starList: Set<String>) -> [MainMenuRowModel] {
        demoScreens.map { [weak self, model] demoScreen in
            return MainMenuRowModel(
                title: demoScreen.title,
                isStarred: starList.contains(demoScreen.title),
                starTapHandler: .immediate { [model] in
                    model.toggleStarred(for: demoScreen.title)
                },
                onSelect: { [weak self] in
                    let controller = demoScreen.viewControllerType.init()
                    self?.navigationController?.pushViewController(controller, animated: true)
                }
            )
        }
    }
}

// MARK: - View Controller Model

private class MainMenuViewControllerModel {
    // Public interface

    private(set) lazy var demoScreens = Property(value: demoScreenArray)
    private(set) lazy var sortStarred = Property(mutableSortStarred)
    private(set) lazy var starList = Property(mutableStarList.map { Set<String>($0) })

    func toggleStarred(for title: String) {
        mutableStarList.modify { list in
            if list.contains(title) {
                list.removeAll { $0 == title }
            } else {
                list.append(title)
            }
        }
    }

    @objc func toggleSortStarred() {
        mutableSortStarred.modify { $0 = !$0 }
    }

    // Private implementation

    private let demoScreenArray: [DemoScreen] = [
        .init("Layout Features", LayoutFeaturesViewController.self),
    ]

    private let mutableStarList = PersistentProperty<[String]>(
        environment: storageEnvironment,
        key: "starList",
        defaultValue: []
    )

    private let mutableSortStarred = PersistentProperty<Bool>(
        environment: storageEnvironment,
        key: "sortStarred",
        defaultValue: false
    )
}

private struct DemoScreen {
    let title: String
    let viewControllerType: UIViewController.Type

    init(_ title: String, _ viewControllerType: UIViewController.Type) {
        self.title = title
        self.viewControllerType = viewControllerType
    }
}

// MARK: - ManagedTableView Classes

private struct MainMenuRowModel: ManagedTableViewCellModel {
    typealias Cell = MainMenuRowCell
    let title: String
    let isStarred: Bool
    let starTapHandler: ActionTrigger<Void>
    let onSelect: (() -> Void)?
}

private class MainMenuRowCell: UITableViewCell, ManagedTableViewCell {
    typealias Model = MainMenuRowModel

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        contentView.configure {
            HStackView {
                $0.alignment = .center
                $0.layout.edges == $0.parentLayout.edges

                UIButton(type: .custom) {
                    $0.layout.size == CGSize(width: 44, height: 44)
                    $0.contentHuggingHorizontal = .required
                    $0.sink(model.map(\.isStarred)) {
                        $0.setImage(UIImage(systemName: $1 ? "star.fill" : "star"), for: .normal)
                    }
                    $0.handleEvents(.touchUpInside, model.map(\.starTapHandler))
                }
                UILabel {
                    $0.bind(\.text) <~ model.map(\.title)
                }
            }
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
