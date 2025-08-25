# Mortar 3

> Mortar 3 is incompatible with previous versions, and aims to solve different problems. Check the git tags to find previous versions.
>
> Mortar 3 is still very much a work in progress, and fundamental API decisions may change at any moment. Please let me know If you choose to use this library for a production app so that I can be more cognizant of impact.

## Project Summary

Mortar is a Swift DSL (Domain Specific Language) that enables declarative, anonymous view hierarchy construction using UIKit. It bridges the gap between traditional UIKit development and SwiftUI-like syntax while maintaining full compatibility with existing UIKit infrastructure.

### Key Differentiators

1. **Anonymous View Construction**: Create complete view hierarchies without naming views or defining them outside of their usage context
2. **Declarative Layout**: Provides a clean syntax for AutoLayout constraints that works with UIKit's native classes
3. **Reactive Integration**: Seamlessly integrates with CombineEx for reactive programming patterns
4. **Managed Views**: Specialized components for UITableView and UICollectionView that work with model-driven data

### Problem Solved

Traditional UIKit development requires:
- Explicit view naming and definition
- Verbose AutoLayout constraint code 
- Complex separation of concerns for reactive state management

Mortar solves these issues by providing:
- Anonymous view creation with inline layout constraints
- Clean, readable syntax for AutoLayout expressions
- Reactive programming patterns that work naturally with UIKit

## Architecture and Design Decisions

### Why Mortar Exists

Mortar was created to address the author's dissatisfaction with SwiftUI's approach while maintaining the benefits of UIKit. The framework:
- Avoids treating entire view hierarchies as immutable structs
- Maintains UIKit's performance characteristics and flexibility 
- Provides clean separation of view logic from business logic
- Enables anonymous, declarative UI construction

### Core Concepts

1. **Result Builder Pattern**: Uses `MortarAddSubviewsBuilder` to enable anonymous view creation within UIKit's initialization blocks
2. **Layout Properties**: Extends UIView with layout properties that provide access to parent and referenced layouts
3. **Reactive Extensions**: Integrates with CombineEx for clean reactive programming patterns
4. **Managed Views**: Provides specialized components for collection views that work with model-driven data

### Technical Approach

The framework leverages Swift's result builder feature to create a DSL that allows:
- Views to be created and added without explicit naming
- Layout constraints to be expressed in a natural, readable syntax  
- Reactive patterns to be applied inline with view construction
- Complex UI hierarchies to be built in a single, declarative block

## Dependencies

### Required Frameworks
- **CombineEx**: Version 0.0.17 or later (used for reactive programming patterns)
- **SwiftUI**: iOS 17+, macOS 14+, tvOS 17+ (for platform support)

### Key Components

The framework is built around these core components:
1. `MortarAddSubviewsBuilder`: Enables anonymous view creation
2. Layout extension properties: Provide constraint capabilities on UIViews  
3. Reactive extensions: Enable reactive programming patterns
4. Managed view classes: Specialized components for collection views

## Usage Examples

### Basic View Construction

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

## Key Features

### Anonymous Views
- No need to name views or define them outside of their usage context
- Complete layout DSL available for anonymous constraints  
- Full UIKit compatibility maintained

### Layout Properties
- Access to parent layout anchors via `parentLayout`
- Multi-constraint guides (e.g., `sides` combines leading/trailing)
- Support for inequalities and constraint modifications
- Layout references for cross-view constraints

### Reactive Programming
- Integration with CombineEx framework
- Inline event handling and property binding
- Publisher sinking for complex view updates

### Managed Views
- Specialized components for UITableView and UICollectionView
- Model-driven data binding
- Automatic view reuse and model updating

## Getting Started

1. Add Mortar as a dependency in your Package.swift:
```swift
dependencies: [
    .package(url: "https://github.com/jmfieldman/Mortar.git", from: "3.0.0")
]
```

2. Import Mortar in your code:
```swift
import Mortar
```

3. Start building anonymous views with declarative syntax

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for more information on how to contribute to Mortar.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
