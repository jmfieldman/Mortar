//
//  Mortar
//
//  Copyright (c) 2016-Present Jason Fieldman - https://github.com/jmfieldman/Mortar
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

public struct MortarAddViewBox {
    /// The view to be added.
    let view: MortarView?
}

@resultBuilder
public struct MortarAddSubviewsBuilder {
    
    /// Builds an expression from a `MortarView?`.
    /// - Parameter expression: The view to be added.
    /// - Returns: A `MortarAddViewBox` containing the provided view.
    public static func buildExpression(_ expression: MortarView?) -> MortarAddViewBox {
        MortarAddViewBox(view: expression)
    }
    
    /// Builds an expression from a `Void`.
    /// - Parameter expression: A void value.
    /// - Returns: A `MortarAddViewBox` with a nil view.
    public static func buildExpression(_ expression: Void) -> MortarAddViewBox {
        MortarAddViewBox(view: nil)
    }
    
    /// Builds a block from multiple `MortarAddViewBox` components.
    /// - Parameter components: An array of `MortarAddViewBox` components.
    /// - Returns: An array of `MortarAddViewBox` components.
    public static func buildBlock(_ components: MortarAddViewBox...) -> [MortarAddViewBox] {
        components
    }
}

public extension MortarView {
    /// Adds subviews to the current view using a result builder.
    /// - Parameter subviewBoxes: A closure that returns an array of `MortarAddViewBox` instances.
    func addSubviews(@MortarAddSubviewsBuilder _ subviewBoxes: () -> [MortarAddViewBox]) {
        process(subviewBoxes())
    }
}

public extension MortarView {
    /// Initializes a `MortarView` with subviews using a result builder.
    /// - Parameter subviewBoxes: A closure that returns an array of `MortarAddViewBox` instances.
    convenience init(@MortarAddSubviewsBuilder _ subviewBoxes: () -> [MortarAddViewBox]) {
        self.init(frame: .zero)
        process(subviewBoxes())
    }
    
    /// Initializes a `MortarView` with subviews using a result builder, allowing the view to be referenced in the closure.
    /// - Parameter subviewBoxes: A closure that takes the current view and returns an array of `MortarAddViewBox` instances.
    convenience init(@MortarAddSubviewsBuilder _ subviewBoxes: (MortarView) -> [MortarAddViewBox]) {
        self.init(frame: .zero)
        process(subviewBoxes(self))        
    }
}

private extension MortarView {
    /// Processes an array of `MortarAddViewBox` instances and adds their views to the current view.
    /// - Parameter addViewBoxes: An array of `MortarAddViewBox` instances.
    func process(_ addViewBoxes: [MortarAddViewBox]) {
        addViewBoxes.compactMap(\.view).forEach(addSubview)
    }
}
