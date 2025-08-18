//
//  ManagedCollectionView.swift
//  Copyright © 2025 Jason Fieldman.
//

#if os(iOS) || os(tvOS)

import UIKit

public final class ManagedCollectionView: UICollectionView {
    public private(set) lazy var sections = BindTarget<ManagedCollectionView, [ManagedCollectionViewSection]>(target: self, keyPath: \.mainSyncSections)
    private var mainSyncSections: [ManagedCollectionViewSection] = [] {
        didSet {
            reloadData()
        }
    }

    private var registeredCellIdentifiers: Set<String> = []
    private var registeredReusableIdentifiers: Set<String> = []

    override public init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)

        self.delegate = self
        self.dataSource = self
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ManagedCollectionView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        mainSyncSections[indexPath.section].items[indexPath.item].onSelect?()
    }
}

extension ManagedCollectionView: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        mainSyncSections.count
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        mainSyncSections[section].items.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let viewModel = mainSyncSections[indexPath.section].items[indexPath.row]
        return viewModel.__dequeueCell(self, indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            mainSyncSections[indexPath.section].header.flatMap {
                $0.__dequeueReusableView(self, indexPath)
            } ?? UICollectionReusableView()
        case UICollectionView.elementKindSectionFooter:
            mainSyncSections[indexPath.section].footer.flatMap {
                $0.__dequeueReusableView(self, indexPath)
            } ?? UICollectionReusableView()
        default:
            UICollectionReusableView()
        }
    }
}

private extension ManagedCollectionView {
    func dequeueCell<T>(_ type: T.Type, for indexPath: IndexPath) -> T where T: Reusable {
        registerCellIfNeeded(type)
        return dequeueReusableCell(withReuseIdentifier: type.reuseIdentifier, for: indexPath) as! T
    }

    func dequeueReusableView<T>(_ type: T.Type, for indexPath: IndexPath) -> T where T: Reusable {
        registerReusableViewIfNeeded(type)
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: type.reuseIdentifier, for: indexPath) as! T
    }
}

private extension ManagedCollectionView {
    func registerCellIfNeeded(_ type: (some Reusable).Type) {
        guard !registeredCellIdentifiers.contains(type.reuseIdentifier) else { return }
        register(type.self, forCellWithReuseIdentifier: type.reuseIdentifier)
        registeredCellIdentifiers.insert(type.reuseIdentifier)
    }

    func registerReusableViewIfNeeded(_ type: (some Reusable).Type) {
        guard !registeredReusableIdentifiers.contains(type.reuseIdentifier) else { return }
        register(type.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: type.reuseIdentifier)
        register(type.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: type.reuseIdentifier)
        registeredReusableIdentifiers.insert(type.reuseIdentifier)
    }
}

private extension ManagedCollectionViewCellModel {
    func __dequeueCell(_ collectionView: ManagedCollectionView, _ indexPath: IndexPath) -> Cell {
        let cell = collectionView.dequeueCell(Cell.self, for: indexPath)
        cell.update(model: self as! Cell.Model)
        return cell
    }
}

private extension ManagedCollectionReusableViewModel {
    func __dequeueReusableView(_ collectionView: ManagedCollectionView, _ indexPath: IndexPath) -> ReusableView {
        let reusableView = collectionView.dequeueReusableView(ReusableView.self, for: indexPath)
        reusableView.update(model: self as! ReusableView.Model)
        return reusableView
    }
}

// MARK: Reusable

/// This internal protocol automates reuse identification for managed cells
/// so that they simply use their class name as the reuse identifier.
private protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}

extension UICollectionReusableView: Reusable {}
extension UICollectionViewCell: Reusable {}

#endif
