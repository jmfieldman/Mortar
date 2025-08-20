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
            updateDataSource()
        }
    }

    private var diffableDataSource: UICollectionViewDiffableDataSource<String, String>?
    private var registeredCellIdentifiers: Set<String> = []
    private var registeredReusableIdentifiers: Set<String> = []

    override public init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)

        self.delegate = self

        self.diffableDataSource = UICollectionViewDiffableDataSource<String, String>(collectionView: self) { [weak self] _, indexPath, _ in
            guard let self else {
                return nil
            }

            let viewModel = mainSyncSections[indexPath.section].items[indexPath.row]
            return viewModel.__dequeueCell(self, indexPath)
        }

        diffableDataSource?.supplementaryViewProvider = { [weak self] _, kind, indexPath -> UICollectionReusableView? in
            guard let self else {
                return nil
            }

            switch kind {
            case UICollectionView.elementKindSectionHeader:
                return mainSyncSections[indexPath.section].header.flatMap {
                    $0.__dequeueReusableView(self, indexPath)
                } ?? UICollectionReusableView()
            case UICollectionView.elementKindSectionFooter:
                return mainSyncSections[indexPath.section].footer.flatMap {
                    $0.__dequeueReusableView(self, indexPath)
                } ?? UICollectionReusableView()
            default:
                return nil
            }
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
            snapshot.appendItems(section.items.map { $0.id as String })
        }
        diffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
}

extension ManagedCollectionView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        mainSyncSections[indexPath.section].items[indexPath.item].onSelect?()
    }
}

private extension ManagedCollectionView {
    func dequeueCell<T>(_ type: T.Type, for indexPath: IndexPath) -> T where T: ClassReusable {
        registerCellIfNeeded(type)
        return dequeueReusableCell(withReuseIdentifier: type.typeReuseIdentifier, for: indexPath) as! T
    }

    func dequeueReusableView<T>(_ type: T.Type, for indexPath: IndexPath) -> T where T: ClassReusable {
        registerReusableViewIfNeeded(type)
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: type.typeReuseIdentifier, for: indexPath) as! T
    }
}

private extension ManagedCollectionView {
    func registerCellIfNeeded(_ type: (some ClassReusable).Type) {
        guard !registeredCellIdentifiers.contains(type.typeReuseIdentifier) else { return }
        register(type.self, forCellWithReuseIdentifier: type.typeReuseIdentifier)
        registeredCellIdentifiers.insert(type.typeReuseIdentifier)
    }

    func registerReusableViewIfNeeded(_ type: (some ClassReusable).Type) {
        guard !registeredReusableIdentifiers.contains(type.typeReuseIdentifier) else { return }
        register(type.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: type.typeReuseIdentifier)
        register(type.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: type.typeReuseIdentifier)
        registeredReusableIdentifiers.insert(type.typeReuseIdentifier)
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
private protocol ClassReusable: AnyObject {
    static var typeReuseIdentifier: String { get }
}

extension ClassReusable {
    static var typeReuseIdentifier: String {
        String(describing: self)
    }
}

extension UICollectionReusableView: ClassReusable {}
extension UICollectionViewCell: ClassReusable {}

#endif
