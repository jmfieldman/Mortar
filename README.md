# Mortar

Mortar is a DSL that allows you to create UIView hierarchies with declarative, anonymous code - similar to SwiftUI.

Consider this inset stack view that contains a label and button:

<img src="Resources/ExampleA.png" width="200px">

You can now declare standard UIKit elements in a manner similar to SwiftUI:

```swift
class MyViewController: UIViewController {
    override func loadView() {
        view = UIContainer {
            $0.backgroundColor = .darkGray

            VStackView {
                $0.backgroundColor = .lightGray
                $0.layout.leading == $0.parentLayout.leadingMargin
                $0.layout.trailing == $0.parentLayout.trailingMargin
                $0.layout.centerY == $0.parentLayout.centerY

                UILabel {
                    $0.layout.height == 44
                    $0.text = "Hello, World!"
                    $0.textColor = .red
                    $0.textAlignment = .center
                }

                UIButton(type: .roundedRect) {
                    $0.setTitle("Button", for: .normal)
                    $0.handleEvents(.touchUpInside) { _ in NSLog("touched") }
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
