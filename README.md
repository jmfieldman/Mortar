![Mortar](/Development/Art/Banner.png)

![Swift 2.2](https://img.shields.io/badge/Swift_2.2-%7E%3E%200.10-orange.svg?style=flat)
![Swift 2.3](https://img.shields.io/badge/Swift_2.3-%7E%3E%200.11-orange.svg?style=flat)
![Swift 3.0](https://img.shields.io/badge/Swift_3.0-%7E%3E%201.0-orange.svg?style=flat)

Mortar allows you to create Auto Layout constraints using concise, simple code statements.

Use this:

```swift
view1.m_right |=| view2.m_left - 12.0
```

Instead of:

```swift
addConstraint(NSLayoutConstraint(
    item:        view1,
    attribute:  .right,
    relatedBy:  .equal,
    toItem:      view2,
    attribute:  .left,
    multiplier:  1.0,
    constant:   -12.0
))
```

Other examples:

```swift
/* Set the size of three views at once */
[view1, view2, view3].m_size |=| (100, 200)

/* Pin a 200px high, same-width view at the bottom of a container */
[view.m_sides, view.m_bottom, view.m_height] |=| [container, container, 200]
```

#### Updating from a version prior to v1.1? Read this!

> A change in the default Mortar constraint priority took effect in v1.1.  Please read the README_DEFAULTS.md file for more information. 

# Why?

Yes, there are many Auto Layout DSLs to choose from.  Mortar was created to fill perceived weaknesses in other offerings:

* Mortar does not use blocks/closures like SnapKit or Cartography. These are distracting and ugly when coding constraints for controllers with many views.

* Mortar is an attempt to get away from chaining methods like SnapKit does.  Chained methods are good for providing semantic meaning to the line of code, but they are hard to parse quickly when you come back to your constraint section later.

* Mortar supports multi-constraint macro properties (like ```m_edges```, ```m_frame```, ```m_size```, etc). SwiftAutoLayout and other operator-based DSLs don't seem to have support for these in a concise form.  Properties are prefixed with m_ to reduce potential for conflict with other View extensions.

* Mortar supports implicit property matching (other frameworks require declared properties on both sides of the statement.)

* Mortar supports implicit tuple processing (you don't need to call out a tuple as a specific element like ```CGRect``` or ```CGSize```).

* Mortar supports multi-view alignment/constraints in a single line.

* Additional goodies, like the ```|+|``` operator to visually construct view hierarchies rather than using tons of sequential calls to ```addSubview()```.

# Installing

You can install Mortar by adding it to your [CocoaPods](http://cocoapods.org/) ```Podfile```:

```ruby
pod 'Mortar'
```

Or you can use a variety of ways to include the ```Mortar.framework``` file from this project into your own.

# Swift Version Support

![Swift 2.2](https://img.shields.io/badge/Swift_2.2-%7E%3E%200.10-orange.svg?style=flat)
![Swift 2.3](https://img.shields.io/badge/Swift_2.3-%7E%3E%200.11-orange.svg?style=flat)
![Swift 3.0](https://img.shields.io/badge/Swift_3.0-%7E%3E%201.0-orange.svg?style=flat)

> This README reflects the updated syntax and constants used in the Swift 3 Mortar release.
> For the Swift 2.x documentation, refer to the ```README_SWIFT2.md``` file.

All versions of Mortar up to 0.10.4 were designed for Swift 2.2.  This is the last release planned for Swift 2.2.  You can
force the usage of this version by specifying:

```ruby
pod 'Mortar', '~> 0.10' 
```

Version 0.11.1 is the release for Swift 2.3 compiled against the Xcode8 GM seed.  Any bugfixes will be released in the 0.11.x version family.  0.11.x is
the only version family that will support Swift 2.3.  You can force usage of this version family by specifying:

```ruby
pod 'Mortar', '~> 0.11' 
```

Version 1.0.0 is the first release of Mortar that is compatible with Swift 3.0.  

```ruby
pod 'Mortar', '~> 1.0' 
```

# Usage

Mortar does not require closures of any kind.  The Mortar operators (```|=|```, ```|>|``` and ```|<|```) instantiate and return constraints that are activated by default.  

Mortar will set ```translatesAutoresizingMaskIntoConstraints``` to ```false``` for every view declared on the left side of an operator.


### Equal, Less or Greater?

There are three mortar operators:

```swift
view1.m_width |=| 40                // Equal
view1.m_width |>| view2.m_width     // Greater than or equal
view1.m_size  |<| (100, 100)        // Less than or equal
```

### Attributes

Mortar supports all of the standard layout attributes:

* ```m_left```                   
* ```m_right```                  
* ```m_top```                    
* ```m_bottom```                 
* ```m_leading```                
* ```m_trailing```               
* ```m_width```                  
* ```m_height```             
* ```m_centerX```            
* ```m_centerY```            
* ```m_baseline```           

And iOS/tvOS spceific attributes:

* ```m_firstBaseline```     
* ```m_leftMargin```         
* ```m_rightMargin```        
* ```m_topMargin```          
* ```m_bottomMargin```       
* ```m_leadingMargin```      
* ```m_trailingMargin```     
* ```m_centerXWithinMargin```
* ```m_centerYWithinMargin``` 

It also supports composite attributes:

* ```m_sides -- (left, right)```
* ```m_caps -- (top, bottom)```
* ```m_size -- (width, height)```
* ```m_center -- (centerX, centerY)```
* ```m_cornerTL -- (top, left)```
* ```m_cornerTR -- (top, right)```
* ```m_cornerBL -- (bottom, left)```
* ```m_cornerBR -- (bottom, right)```
* ```m_edges -- (top, left, bottom, right)```
* ```m_frame -- (top, left, width, height)```

### Implicit Attributes

_Mortar will do its best to infer implicit attributes!_

The ```m_edges``` attribute is implied when no attributes are declared on either side: 

```swift
view1.m_edges |=| view2.m_edges     // These two lines
view1         |=| view2             // are equivalent.
```

If an attribute is declared on one side, it is implied on the other:

```swift
view1.m_top   |>| view2             // These two lines
view1         |>| view2.m_top       // are equivalent.
```

You are required to put attributes on both sides if they are not the same:

```swift
view1.m_top   |<| view2.m_bottom
```

### Using Layout Guides

On iOS you can use the layout guides of a ```UIViewController```.  An example from inside ```viewDidLoad()``` that puts a view just below the top layout guide:

```swift
view1.m_top   |<| self.m_topLayoutGuideBottom
```

### Multipliers and Constants

Auto Layout constraints can have multipliers and constants applied to them.  This is done with normal arithmetic operators.  Attributes must be explicitly declared on the _right_ side When arthmetic operators are used.

```swift
view1.m_size  |=| view2.m_size  * 2         // Multiplier   
view1.m_left  |>| view2.m_right + 20        // Constant
view1         |<| view2.m_top   * 1.4 + 20  // Both -- m_top is implied on the left
```

You can also set attributes directly to constants:

```swift
view1.m_width |=| 100                // Single-dimension constants
view1.m_size  |=| 150.0              // Set multiple dimensions to the same constant
view1.m_size  |>| (200, 50)          // Set multiple dimensions to a tuple value
view1.m_frame |<| (0, 0, 50, 100)    // Four-dimension tuples supported
```

Arithmetic can be done using tuples for multi-dimension attributes:

```swift
view1.m_size  |=| view2.m_size + (50, 30)
view1.m_size  |>| view2.m_size * (2, 3) + (10, 10)
```

The special inset operator ```~``` operates on multi-dimension attributes:

```swift
view1         |=| view2.m_edges ~ (20, 20, 20, 20)  // view1 is inset by 20 points on each side
```

### Attributes in Tuples

You are allowed to put attributes inside of tuples:

```swift
view1.m_size  |=| (view2.m_width, 100)
```

### Multiple Simultaneous Constraints

Multiple constraints can be created using arrays:

```swift
view1 |=| [view2.m_top, view3.m_bottom, view4.m_size]

/* Is equivalent to: */
view1 |=| view2.m_top
view1 |=| view3.m_bottom
view1 |=| view4.m_size
```

```swift
[view1, view2, view3].m_size |=| (100, 200)

/* Is equivalent to: */
[view1.m_size, view2.m_size, view3.m_size] |=| (100, 200)

/* Is equivalent to: */
view1.m_size |=| (100, 200)
view2.m_size |=| (100, 200)
view3.m_size |=| (100, 200)
```

This might be a convenient way to align an array of views, for example:

```swift
[view1, view2, view3].m_centerY |=| otherView
[view1, view2, view3].m_height  |=| otherView
```

If you put arrays on both sides of the constraint, it will only constrain elements at the same index.  That is:

```swift
[view1.m_left, view2, view3] |=| [view4.m_right, view5, view6]

/* Is equivalent to: */
view1.m_left |=| view4.m_right
view2        |=| view5
view3        |=| view6
```

You can use this to create complex constraints on one line.  For example, to create a 200-point high view that sits at the bottom of a container view:

```swift
[view.m_sides, view.m_bottom, view.m_height] |=| [container, container, 200]
```

### Priority

You can assign priority to constraints using the ```!``` operator.  Valid priorities are:

* ```.low```, ```.default```, ```.high```, ```.required```
* Any ```UILayoutPriority``` value

```swift
v0 |=| self.container.m_height
v1 |=| self.container.m_height ! .low
v2 |=| self.container.m_height ! .default
v3 |=| self.container.m_height ! .high
v4 |=| self.container.m_height ! .required
v5 |=| self.container.m_height ! 300
```

You can also put priorities inside tuples or arrays:

```swift
view1        |=| [view2.m_caps   ! .high, view2.m_sides      ! .low]  // Inside array
view1.m_size |=| (view2.m_height ! .high, view2.m_width + 20 ! .low)  // Inside tuple
```

### Default Priority

By default, constraints are given priority equal to 500 (out of 1000).  Often times if you
may want large batches of constraints to have a different priority, and it is messy to include something like 
```! .required``` after every constraint.

You can change the global base default value by using ```set```:

```swift
MortarDefault.priority.set(base: .required)
```

You can use this in the ```AppDelegate``` to change the app-wide default constraint priority.

Because this can only be changed on the main thread, it is safe to call just before your
layout code.  Keep in mind it will affect all future Mortar contraints!  If you are adjusting
the default for a single layout section, it is usually wiser to use the stack mechanism
to change the default priority used in a frame of code:

```swift
MortarDefault.priority.push(.required)

v1 |=| v2 // Given priority .required automatically
...

MortarDefault.priority.pop()
```

You may only call the push/pop methods on the main thread, and Mortar will raise an exception if you do not
properly balance your pushes and pops.

### Change Priority

You can change the priority of a ```MortarConstraint``` or ```MortarGroup``` by calling the ```changePriority``` method.  This takes either a ```MortarLayoutPriority``` enum, or a ```UILayoutPriority``` value:

```swift
let c = view1 |=| view2 ! .low     // Creates 4 low-priority constraints (1 per edge)
c.changePriority(to: .high)            // Sets all 4 constraints to high priority
```

Remember that you can't switch to or from ```Required``` from any other priority level (this is an Auto Layout limitation.)


### Create Deactivated Constraints

You can use the ```~~``` operator as a shorthand for constraint activation and deactivation.  This makes the most sense as part of constraint declarations when you want to create initially-deactivated constraints:

```swift
let constraint = view1 |=| view2 ~~ .deactivated

// Later on, it makes more semantic sense to call .activate():
constraint.activate()

// Even though this is functionally equivalent:
constraint ~~ .activated

// It works with groups too:
let group = [
    view1 |=| view2
    view3 |=| view4
] ~~ .deactivated

```

# Keeping Constraint References

The basic building block is the ```MortarConstraint```, which wraps several ```NSLayoutConstraint``` instances that are relevant to multi-affinity attributes like ```m_frame``` (4) or ```m_size``` (2).

You can capture a ```MortarConstraint``` for later reference:

```swift
let constraint = view1.m_top |=| view2.m_bottom
```

The raw ```NSLayoutConstraint``` elements can be accessed through the ```layoutConstraints``` accessor:

```swift
let mortarConstraint = view1.m_top |=| view2.m_bottom
for rawLayoutConstraint in mortarConstraint.layoutConstraints {
    ...
}
```

You can create an entire group of constraints:

```swift
let group = [
    view1.m_origin |=| view2,
    view1.m_size   |=| (100, 100)
]
```

Mortar includes a convenient typealias to refer to arrays of ```MortarConstraint``` objects:

```swift
public typealias MortarGroup = [MortarConstraint]
```

You can now activate/deactivate constraints:

```swift
let constraint = view1.m_top |=| view2.m_bottom

constraint.activate()
constraint.deactivate()

let group = [
    view1.m_origin |=| view2,
    view1.m_size   |=| (100, 100)
]

group.activate()
group.deactivate()
```

### Replacing Constraints and Groups of Constraints

Constraints and groups have a ```replace``` method that deactives the target and activates the parameter:

```swift
let constraint1 = view1.m_sides |=| view2
let constraint2 = view1.m_width |=| view2 ~~ .deactivated

constraint1.replace(with: constraint2)

let group1 = [
    view1.m_sides |<| view2,
    view1.m_caps  |>| view2,
]
        
let group2 = [
    view1.m_width |=| view2
] ~~ .deactivated

group1.replace(with: group2)
```

## Compression Resistance and Content Hugging

Mortar provides some shorthand properties to adjust a view's compression resistance and content hugging priorities:

```swift
// Set both horizontal and vertical compression resistance priority simultaneously:
view1.m_compResist = 1

// Set horizontal and vertical compression resistance independently:
view1.m_compResistH = 300
view1.m_compResistV = 800

// Set both horizontal and vertical content hugging priority simultaneously:
view1.m_hugging = 1

// Set horizontal and vertical content hugging independently:
view1.m_huggingH = 300
view1.m_huggingV = 800
```

You can get the horizontal and vertical values independently, but not together:

```swift
// These getters are fine:
let c1 = view1.m_compResistH
let c2 = view1.m_compResistV
let h1 = view1.m_huggingH
let h2 = view1.m_huggingV

// These getters raise exceptions:
let cr = view1.m_compResist
let hg = view1.m_hugging
```


# Visual View Hierarchy Creation

Mortar provides the ```|+|``` and ```|^|``` operators to quickly add a subview or array of subviews.  This can be used to create visual expressions of the view hierarchy.

Now this:

```swift
self.view.addSubview(backgroundView)
self.view.addSubview(myCoolPanel)
myCoolPanel.addSubview(nameLabel)
myCoolPanel.addSubview(nameField)
```

Turns into:

```swift
    self.view |+| [
        backgroundView,
        myCoolPanel |+| [
            nameLabel,
            nameField
        ]
    ]
```

Alternatively, if you want to see the upper subviews at the beginning of the array (so that visually, the views closer to the top of the file are closer to the user), use the ```|^|``` operator:

```swift
    self.view |^| [
        myCoolPanel |^| [      // myCoolPanel is added second and
            nameField,         // is therefore on top of backgroundView
            nameLabel
        ],
        backgroundView        
    ]
```

### Initializing NSObject at Creation

Mortar extends ```NSObject``` with the ```m_create``` class function.  This class function performs a parameter-less
instantiation of the class, and passes the new instance into the provided closure.  This allows you to configure
an instance at creation-time, which is really nice for compartmentalizing view configuration.

As you can see in the below example, configuration of the view is separated from the code needed to attach it
to the view controller hierarchy and layout.

```swift
class MyController: UIViewController {

    // Instantiation/configuration
    let myLabel = UILabel.m_create {
        $0.text          = "Some Text"
        $0.textAlignment = .center
        $0.textColor     = .red
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Hierarchy
        self.view |+| [
            myLabel
        ]

        // Layout
        myLabel.m_top     |=| self.view
        myLabel.m_centerX |=| self.view
    }
}
```

