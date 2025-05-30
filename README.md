# Mortar

Mortar is a DSL that allows you to create UIView hierarchies with declarative, anonymous code - similar to SwiftUI:

```swift
class MyViewController: UIViewController {
    override func loadView() {
        view = UIContainer { container in
            container.backgroundColor = .darkGray
            
            VStackView {
                $0.backgroundColor = .lightGray
                $0.layout.leading == container.layout.leadingMargin
                $0.layout.trailing == container.layout.trailingMargin
                $0.layout.centerY == container.layout.centerY
                
                UILabel {
                    $0.layout.height == 44
                    $0.text = "Hello, World!"
                    $0.textColor = .red
                    $0.textAlignment = .center
                }
                
                UIButton(type: .roundedRect) {
                    $0.setTitle("Button", for: .normal)
                    $0.handleEvents(.touchUpInside, touchAction)
                }
            }
        }
    }
}
```

Which creates:

<img src="Resources/ExampleA.png" width="200px">

