//
//  ManagedTableView.swift
//  Copyright © 2025 Jason Fieldman.
//

import UIKit

public final class ManagedTableView: UITableView {
    public private(set) lazy var sections = BindTarget<ManagedTableView, [ManagedTableViewSection]>(target: self, keyPath: \.mainSyncSections)
    private var mainSyncSections: [ManagedTableViewSection] = [] {
        didSet {
            reloadData()
        }
    }

    private var registeredCellIdentifiers: Set<String> = []
    private var registeredHeaderIdentifiers: Set<String> = []

    override public init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)

        self.sectionHeaderTopPadding = 0
        self.delegate = self
        self.dataSource = self
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ManagedTableView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        mainSyncSections[section].header != nil ? UITableView.automaticDimension : 0.0
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        mainSyncSections[section].footer != nil ? UITableView.automaticDimension : 0.0
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        mainSyncSections[indexPath.section].rows[indexPath.row].onSelect?()
    }
}

extension ManagedTableView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        mainSyncSections.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mainSyncSections[section].rows.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = mainSyncSections[indexPath.section].rows[indexPath.row]
        return viewModel.__dequeueCell(self, indexPath)
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        mainSyncSections[section].header.flatMap {
            $0.__dequeueHeaderFooter(self)
        }
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        mainSyncSections[section].footer.flatMap {
            $0.__dequeueHeaderFooter(self)
        }
    }
}

extension ManagedTableView {
    func dequeueCell<T>(_ type: T.Type, for indexPath: IndexPath) -> T where T: Reusable {
        registerCellIfNeeded(type)
        return dequeueReusableCell(withIdentifier: type.reuseIdentifier, for: indexPath) as! T
    }

    func dequeueHeaderFooterView<T>(_ type: T.Type) -> T where T: Reusable {
        registerHeaderFooterIfNeeded(type)
        return dequeueReusableHeaderFooterView(withIdentifier: type.reuseIdentifier) as! T
    }
}

extension ManagedTableView {
    func registerCellIfNeeded(_ type: (some Reusable).Type) {
        guard !registeredCellIdentifiers.contains(type.reuseIdentifier) else { return }
        register(type.self, forCellReuseIdentifier: type.reuseIdentifier)
        registeredCellIdentifiers.insert(type.reuseIdentifier)
    }

    func registerHeaderFooterIfNeeded(_ type: (some Reusable).Type) {
        guard !registeredHeaderIdentifiers.contains(type.reuseIdentifier) else { return }
        register(type.self, forHeaderFooterViewReuseIdentifier: type.reuseIdentifier)
        registeredHeaderIdentifiers.insert(type.reuseIdentifier)
    }
}

private extension ManagedTableViewCellModel {
    func __dequeueCell(_ tableView: ManagedTableView, _ indexPath: IndexPath) -> Cell {
        let cell = tableView.dequeueCell(Cell.self, for: indexPath)
        cell.update(model: self as! Cell.Model)
        cell.selectionStyle = .none
        return cell
    }
}

private extension ManagedTableViewHeaderFooterViewModel {
    func __dequeueHeaderFooter(_ tableView: ManagedTableView) -> Header {
        let headerFooter = tableView.dequeueHeaderFooterView(Header.self)
        headerFooter.update(model: self as! Header.Model)
        return headerFooter
    }
}
