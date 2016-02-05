
Mortar is a concise, flexible Auto Layout DSL for iOS, OSX, and tvOS.

```swift
import Mortar

class MyViewController: UIViewController {

    lazy var view1 = UIView()
    lazy var view2 = UIView()
    lazy var view3 = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view |+| [
        	view1, 
        	view2 |+| [
        		view3
        	]
        ]
        
        view1.m_center   |=| self.view        
        view2.m_cornerTL |=| view1.m_cornerBL

        [view1, view2].m_size |>| (100, 100) ! .High
        [view1, view2].m_size |<| (200, 200) ! 250

        let view3group = mortar_group {
        	view3.m_sides |=| (0, view2)
        	view3.m_caps  |=| (view1.m_top + 50, view2.m_bottom * 0.5 + 40)
        }
    }

}
```

## Benefits

* No blocks unless you are making explicit constraint groups.
* Implicit attribute detection allows tighter expressions.
* Create multiple related constraints in one statement using arrays.
* Powerful parsing engine allows deeply embedded attributes/tuples.
* Visual view hierarchy declaration.
* Standard attribute arithmetic and priority support.


## Requirements

* iOS 8.0+ / OSX 10.10+
* Swift 2.1
* Xcode 7.0+

## Usage


