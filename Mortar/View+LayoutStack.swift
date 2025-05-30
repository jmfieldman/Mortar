//
//  View+LayoutStack.swift
//  Copyright © 2025 Jason Fieldman.
//

class MortarMainThreadLayoutStack {
    public static let shared = MortarMainThreadLayoutStack()

    private var stackDepth: Int = 0
    private var accumulator: [MortarConstraint] = []

    private init() {
        DispatchQueue.main.setSpecific(key: key, value: value)
        accumulator.reserveCapacity(4096)
    }

    func isMainThread() -> Bool {
        DispatchQueue.getSpecific(key: key) == value
    }

    static func execute(_ block: () -> Void) {
        shared.push()
        block()
        shared.pop()
    }

    private func push() {
        if !isMainThread() {
            MortarError.emit("Attempted to push layout stack off main thread")
        }
        stackDepth += 1
    }

    private func pop() {
        if !isMainThread() {
            MortarError.emit("Attempted to pop layout stack off main thread")
        }
        if stackDepth <= 0 {
            MortarError.emit("Attempted to pop layout stack with invalid depth: \(stackDepth)")
        }
        stackDepth -= 1

        // Flush the accumulator if the stack is empty
        if stackDepth == 0 {
            for item in accumulator {
                item.layoutConstraint?.isActive = item.source.startActivated
            }
        }
    }

    func insideStack() -> Bool {
        stackDepth > 0
    }

    func accumulate(constraints: [MortarConstraint]) {
        accumulator.append(contentsOf: constraints)
    }
}

private let key = DispatchSpecificKey<UInt8>()
private let value: UInt8 = 0
