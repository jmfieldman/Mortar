//
//  ManagedTableView.swift
//  Copyright © 2025 Jason Fieldman.
//

#if os(iOS) || os(tvOS)

import UIKit

public final class ManagedTableView: UITableView {
    public private(set) lazy var sections = BindTarget<ManagedTableView, [ManagedTableViewSection]>(target: self, keyPath: \.mainSyncSections)
    private var mainSyncSections: [ManagedTableViewSection] = [] {
        didSet {
            updateDataSource()
        }
    }

    private var diffableDataSource: UITableViewDiffableDataSource<String, String>?
    private var registeredCellIdentifiers: Set<String> = []
    private var registeredHeaderIdentifiers: Set<String> = []

    override public init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)

        self.sectionHeaderTopPadding = 0
        self.delegate = self

        self.diffableDataSource = UITableViewDiffableDataSource<String, String>(tableView: self) { [weak self] _, indexPath, _ in
            guard let self else {
                return nil
            }
            let viewModel = mainSyncSections[indexPath.section].rows[indexPath.row]
            return viewModel.__dequeueCell(self, indexPath)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<String, String>()
        for section in mainSyncSections {
            snapshot.appendSections([section.id])
            snapshot.appendItems(section.rows.map { $0.id as String })
        }
        diffableDataSource?.apply(snapshot, animatingDifferences: false)
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

private extension ManagedTableView {
    func dequeueCell<T>(_ type: T.Type, for indexPath: IndexPath) -> T where T: ClassReusable {
        registerCellIfNeeded(type)
        return dequeueReusableCell(withIdentifier: type.typeReuseIdentifier, for: indexPath) as! T
    }

    func dequeueHeaderFooterView<T>(_ type: T.Type) -> T where T: ClassReusable {
        registerHeaderFooterIfNeeded(type)
        return dequeueReusableHeaderFooterView(withIdentifier: type.typeReuseIdentifier) as! T
    }
}

private extension ManagedTableView {
    func registerCellIfNeeded(_ type: (some ClassReusable).Type) {
        guard !registeredCellIdentifiers.contains(type.typeReuseIdentifier) else { return }
        register(type.self, forCellReuseIdentifier: type.typeReuseIdentifier)
        registeredCellIdentifiers.insert(type.typeReuseIdentifier)
    }

    func registerHeaderFooterIfNeeded(_ type: (some ClassReusable).Type) {
        guard !registeredHeaderIdentifiers.contains(type.typeReuseIdentifier) else { return }
        register(type.self, forHeaderFooterViewReuseIdentifier: type.typeReuseIdentifier)
        registeredHeaderIdentifiers.insert(type.typeReuseIdentifier)
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

// MARK: Reusable

/// This internal protocol automates reuse identification for managed cells
/// so that they simply use their class name as the reuse identifier.
private protocol ClassReusable: AnyObject {
    static var typeReuseIdentifier: String { get }
}

extension ClassReusable {
    static var typeReuseIdentifier: String {
        String(describing: self)
    }
}

extension UITableViewHeaderFooterView: ClassReusable {}
extension UITableViewCell: ClassReusable {}

#endif
