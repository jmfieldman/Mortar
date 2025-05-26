//
//  MortarViewAliases.swift
//  Copyright © 2025 Jason Fieldman.
//

public typealias ZStackView = MortarView

public class HStackView: MortarStackView {
    override public init(frame: CGRect) {
        super.init(frame: frame)
        axis = .horizontal
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class VStackView: MortarStackView {
    override public init(frame: CGRect) {
        super.init(frame: frame)
        axis = .vertical
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
