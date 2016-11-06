## Important Notice for Updating to Mortar v1.1+

*Please read this if you are updating Mortar from a version before v1.1 to a version at or beyond v1.1*

Prior to v1.1, the default Mortar constraint priority was 500.  It was an erroneous assumption by me (Jason) that
NSLayoutContraints created in normal Auto Layout functions were given a priority of 500 unless otherwise specified.  In fact,
Apple gives constraints a default value 1000 (ref: [```NSLayoutConstraint```](https://developer.apple.com/reference/uikit/nslayoutconstraint)).

In Mortar v1.1, to eliminate this priority mismatch and make the library less confusing to new users, the default Mortar constraint priority was changed from 500 to 1000, to match Apple's default NSLayoutContraint priority.  What this means from a coding perspective:

```swift
// prior to v1.1:
view1 |=| view2 // <-- given priority 500 (.medium)

// v1.1 or beyond:
view1 |=| view2 // <-- given priority 1000 (.required)
```

If your codebase was created with Mortar previous to v1.1, and your code relies on the assumption that the default Mortar priority is 500, you can put the following in your ```AppDelegate```'s ```application:didFinishLaunchingWithOptions:``` before any other Mortar call:

```swift
// Set base constraint priority to 500 (.medium):
MortarDefault.priority.set(base: .medium)
```

