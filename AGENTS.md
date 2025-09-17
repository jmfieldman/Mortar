# Guide for AI Agents: Using Mortar Library for Swift UI Development

This guide provides comprehensive instructions for AI agents on how to use the Mortar library to create iOS UI elements declaratively in Swift.

## Overview

Mortar is a Swift DSL (Domain Specific Language) that enables declarative, anonymous view hierarchy construction using UIKit. It bridges the gap between traditional UIKit development and SwiftUI-like syntax while maintaining full compatibility with existing UIKit infrastructure.

## Key Features

1. **Anonymous View Construction**: Create complete view hierarchies without naming views or defining them outside of their usage context
2. **Declarative Layout**: Provides a clean syntax for AutoLayout constraints that works with UIKit's native classes
3. **Reactive Integration**: Seamlessly integrates with CombineEx for reactive programming patterns
4. **Managed Views**: Specialized components for UITableView and UICollectionView that work with model-driven data

## Core Concepts

### Result Builder Pattern
Mortar uses `MortarAddSubviewsBuilder` to enable anonymous view creation within UIKit's initialization blocks. This allows views to be created and added inline without explicit naming.

### Layout Properties
Views have access to layout properties that provide constraint capabilities:
- `layout`: Access to the view's own layout anchors
- `parentLayout`: Access to parent layout anchors for constraints
- `referencedLayout(_:)`: Access to referenced layout anchors for cross-view constraints

### Reactive Programming
Mortar integrates with CombineEx framework for reactive programming patterns:
- Event handling with `handleEvents()`
- Property binding with `bind()`
- Publisher sinking with `sink()`

## Basic Usage Patterns

### Creating Views with Anonymous Hierarchy

```swift
import Mortar

class MyViewController: UIViewController {
    override func loadView() {
        view = UIContainer {
            $0.backgroundColor = .darkGray

            UIVStack {
                $0.alignment = .center
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

### Layout Constraints

```swift
// Basic constraint against parent layout
$0.layout.centerY == $0.parentLayout.centerY

// Multi-constraint guide in single expression  
$0.layout.sides == $0.parentLayout.sideMargins

// Constraint to constants
$0.layout.size == CGSize(width: 100, height: 100)

// Inequalities
$0.layout.trailing == $0.parentLayout.trailing

// Constraint modification after creation
let group = $0.layout.center == $0.parentLayout.center
group.layoutConstraints.first?.constant += 20
```

### Reactive Programming

```swift
// Handle UIControl events with CombineEx Actions
$0.handleEvents(.valueChanged, model.toggleStateAction) { $0.isOn }

// Bind publishers to view properties
$0.bind(\.text) <~ model.toggleState.map { "Toggle is \($0)" }

// Sink publishers for complex view updates
$0.sink(model.someVoidPublisher) { view in
  // Void publishers handling
}

$0.sink(model.someValuePublisher) { view, value in
  // Value publishers handling
}
```

## Working with Managed Views

### Managed Table Views

```swift
// Define model and cell classes
private struct SimpleTextRowModel: ManagedTableViewCellModel {
    typealias Cell = SimpleTextRowCell

    let text: String
}

private final class SimpleTextRowCell: UITableViewCell, ManagedTableViewCell {
    typealias Model = SimpleTextRowModel
}

// Use in view controller
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

## Layout Guide Attributes

Mortar provides virtual attributes that represent multiple sub-attributes:

- **Position attributes**: `left`, `right`, `top`, `bottom`, `leading`, `trailing`, `centerX`, `centerY`
- **Size attributes**: `width`, `height`
- **Multi-attribute guides**:
  - `sides`: combines leading and trailing
  - `caps`: combines top and bottom
  - `size`: combines width and height
  - `edges`: combines top, leading, bottom, trailing
  - `center`: combines centerX and centerY

## Best Practices for AI Agents

1. **Use Anonymous Views**: Create views inline without explicit naming to keep code clean and readable
2. **Leverage Layout Properties**: Use `layout`, `parentLayout`, and `referencedLayout(_:)` for constraint management
3. **Apply Reactive Patterns**: Use CombineEx integration for handling events and binding data
4. **Utilize Managed Views**: For table and collection views, use the managed view components for model-driven data binding
5. **Follow Result Builder Pattern**: Use the `@MortarAddSubviewsBuilder` syntax for creating view hierarchies
6. **Use Multi-Constraint Guides**: Take advantage of virtual attributes like `sides`, `edges`, and `center` for cleaner constraint expressions

## Common Patterns

### Creating a Simple Container View
```swift
UIContainer {
    $0.backgroundColor = .white
    
    UILabel {
        $0.text = "Sample Text"
        $0.layout.center == $0.parentLayout.center
    }
}
```

### Creating a Stack View with Constraints
```swift
UIVStack {
    $0.axis = .vertical
    $0.spacing = 10
    $0.layout.edges == $0.parentLayout.edges
    
    UILabel {
        $0.text = "Header"
        $0.layout.height == 44
    }
    
    UILabel {
        $0.text = "Content"
        $0.layout.height == 100
    }
}
```

### Creating a Button with Event Handling
```swift
UIButton(type: .system) {
    $0.setTitle("Tap Me", for: .normal)
    $0.handleEvents(.touchUpInside) { 
        print("Button tapped!")
    }
}
```

## Integration with Existing UIKit Code

Mortar maintains full compatibility with existing UIKit infrastructure:
- All views created with Mortar are standard UIKit views
- Existing view controllers and navigation patterns work unchanged
- Can be mixed with traditional UIKit code in the same project
- No need to rewrite existing codebases to adopt Mortar

### Import Mortar in your code:

```swift
import Mortar
```

