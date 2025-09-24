//
//  StandardTableViewCell.swift
//  Copyright © 2025 Jason Fieldman.
//

#if os(iOS) || os(tvOS)

import CombineEx
import UIKit

public final class StandardTableViewCell: UITableViewCell, ManagedTableViewCell {
    public struct Model: ManagedTableViewCellModel, ArbitrarilyIdentifiable {
        public typealias Cell = StandardTableViewCell

        public let id: String
        public let text: String
        public let textStyle: AttributeContainer
        public let image: UIImage?
        public let accessoryType: UITableViewCell.AccessoryType
        public let accessoryView: (@MainActor () -> UIView?)?
        public let onSelect: ((ManagedTableView, IndexPath) -> Void)?

        public init(
            id: String = UUID().uuidString,
            text: String,
            textStyle: AttributeContainer = AttributeContainer(),
            image: UIImage? = nil,
            accessoryType: UITableViewCell.AccessoryType = .none,
            accessoryView: (@MainActor () -> UIView?)? = nil,
            onSelect: ((ManagedTableView, IndexPath) -> Void)? = nil
        ) {
            self.id = id
            self.text = text
            self.textStyle = textStyle
            self.image = image
            self.accessoryType = accessoryType
            self.accessoryView = accessoryView
            self.onSelect = onSelect
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        textLabel?.bind(\.textStyle) <~ model.map(\.textStyle)
        textLabel?.bind(\.styledText) <~ model.map(\.text)
        imageView?.bind(\.isHidden) <~ model.map { $0.image == nil }
        imageView?.bind(\.image) <~ model.map(\.image)

        bind(\.accessoryType) <~ model.map(\.accessoryType)
        bind(\.accessoryView) <~ model.map { $0.accessoryView?() }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#endif
