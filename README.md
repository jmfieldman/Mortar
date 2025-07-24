# Mortar 3

> Mortar 3 is incompatible with previous versions, and aims to solve different problems. Check the git tags to find previous versions.

Mortar is a DSL that allows you to create UIView hierarchies with declarative, anonymous syntax. Its goal is to provide the best of SwiftUI without its [perceived shortcomings](WHY.md).

The following example is all based on UIKit classes:

```swift
import Mortar 

class MyViewController: UIViewController {
    override func loadView() {
        view = UIContainer {
            $0.backgroundColor = .darkGray

            VStackView {
                $0.backgroundColor = .lightGray
                $0.layout.sides == $0.parentLayout.sideMargins
                $0.layout.centerY == $0.parentLayout.centerY

                UILabel {
                    $0.layout.height == 44
                    $0.text = "Hello, World!"
                    $0.textColor = .red
                    $0.textAlignment = .center
                }

                UIButton(type: .roundedRect) {
                    $0.setTitle("Button", for: .normal)
                    $0.handleEvents(.touchUpInside) { NSLog("touched \($0)") }
                }
            }
        }
    }
}
```

Some things to notice above:

* No views in the hierarchy are named, or defined outside of this function.
* A complete layout DSL is available to constrain views anonymously.
* You can still use all of the UIKit properties and behaviors as expected.
* Event handling can be declared inline as well.

This is only a partial list of Mortar features. Read on for more!

### Anonymous Views

The anonymous view layout mechanism is provided by the `MortarAddSubviewsBuilder` result builder:

```swift
init(@MortarAddSubviewsBuilder _ subviewBoxes: () -> [MortarAddViewBox]) {
    self.init(frame: .zero)
    MortarMainThreadLayoutStack.execute {
        process(subviewBoxes())
    }
}
```

This result builder attempts to cast each expression inside the UIView's init block into a `MortarAddViewBox`. If that cast is possible, and the expression is a UIView subclass, then it is added to subviews of the receiving objects. The `MortarMainThreadLayoutStack` wrapper ensures that the layout expressions are only performed after the subviews have been added (to avoid Autolayout crashes.)

The nature of the Swift language allows other types of expressions to still execute, so non-view expressions still work (e.g. variable declarations.)

Magic, basically.

### Layout Properties

To facilitate easy anonymous layout constraints, new properties are added to UIViews, e.g.:

```swift
// `parentLayout` refers to the immediate ancestor
$0.layout.centerY == $0.parentLayout.centerY

// Multi-constraint guides in a single expression
// (e.g. `sides` combines `leading` and `trailing`)
$0.layout.sides == $0.parentLayout.sideMargins

// You can equate to constants
$0.layout.size == CGSize(width: 100, height: 100)

// Inequalities are supported
$0.layout.trailing == $0.parentLayout.trailing

// The expression returns a constraint group that you can modify
let group = $0.layout.center == $0.parentLayout.center
group.layoutConstraints.first?.constant += 20
```

There are more examples and features to explore in the [LayoutFeaturesViewController](Examples/MortarDemo/MortarDemo/DemoPages/LayoutFeatures.swift) example code.

### Reactive Properties

Reactive extensions are provided to handle UIView input/output/updates in a clean, anonymous manner. Many of these extensions rely on the [CombineEx](https://github.com/jmfieldman/CombineEx) framework.

Most of these are designed to work with a provided view model, to help encapsulate the view's business logic into a separate entity.

```
// UIControl events can trigger CombineEx Actions with the given input value.
$0.handleEvents(.valueChanged, model.toggleStateAction) { $0.isOn }

// Publishers can be bound to any compatible keypath.
$0.bind(\.text) <~ model.toggleState.map { "Toggle is \($0)" }

// Publishers from the model can be sunk directly in the view hierarchy
// when their new value needs to perform some complex task with the view.
// The `view` block parameter refers to the anonymous $0 receiving view
$0.sink(model.someVoidPublisher) { view in
  // Void publishers
}

$0.sink(model.someValuePublisher) { view, value in
  // Value publishers
}
```

There are lots of other ways to use reactive properties on anonymous views. Check out [MortarReactive.swift](Mortar/MortarReactive.swift) and [ReactiveFeaturesViewController](Examples/MortarDemo/MortarDemo/DemoPages/ReactiveFeatures.swift).

### ManagedTableView

While this library is opinionated that constructing a complete view hierarchy out of model structs is ridiculous, it *is* appropriate for powering collection-esque views like UITableView, UICollectionView, and even UIStackView (in some cases).

The ManagedX classes abstract this for you, so that you can power your collections with data models, and the internal view will automatically instantiate/reuse the corresponding UIView subclass.

First, declare any number of `ManagedTableViewCellModel` and their corresponding `ManagedTableViewCell`:

```swift
private struct SimpleTextRowModel: ManagedTableViewCellModel {
    typealias Cell = SimpleTextRowCell

    let text: String
    // ... other immutable properties ...
}

private final class SimpleTextRowCell: UITableViewCell, ManagedTableViewCell {
    typealias Model = SimpleTextRowModel

    // The ManagedTableViewCell provides an internal `model` publisher
    // that emits its corresponding model value (updated when the cell
    // is reused.)
}
```

Then you can bind any Publisher/Property to the `sections` sink as long as it provides a `[ManagedTableViewSection]`. The row models are internally mapped to their corresponding cell classes, which are instantiated/reused and have their models updated.

This lets you provide immutable view models for your collection cells from your controller's top-level view model (or wherever you want to generate them.)

```swift
class BasicManagedTableViewController: UIViewController {
    override func loadView() {
        view = UIContainer {
            $0.backgroundColor = .white

            ManagedTableView {
                $0.layout.edges == $0.parentLayout.edges
                $0.sections <~ Property(value: [self.makeSection()])
            }
        }
    }
    
    private func makeSection() -> ManagedTableViewSection {
        ManagedTableViewSection(
            rows: [
                SimpleTextRowModel(text: "Simple row 1"),
                SimpleTextRowModel(text: "Simple row 2"),
                SimpleTextRowModel(text: "Simple row 3"),
            ]
        )
    }
}
```