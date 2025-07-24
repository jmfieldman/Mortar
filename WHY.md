# Why

### Subjective Opinion

I have not used SwiftUI much in a professional capacity. 

The last time was making the Bird App Clip, which reused a lot of our existing ReactiveSwift tooling. So a lot of the "View Model" code was translating from Property/SignalProducers into the @Published values from the older SwiftUI syntax. I was not really impressed by this, nor the constant incredulity I would feel trying to figure out the correct SwiftUI syntax for various UI goals.

I then published an app to the App Store (before @Observable, no structured concurrency) which used Combine. I really did like that I could compose anonymous view hierarchies, and I did like that the SwiftUI semantics really forced me to isolate my view and view model code into separate classes.

But I really do hate that the concept that the entire view hierarchy is just View structs. It feels like an overcorrection. And I really dislike the almost bespoke-per-use-case API that is really hard to internalize, coming from UIKit.

In a few random side dabblings in SwiftUI, I always hit some wall attempting to get the UI to do a specific task. One time it was the keyboard bouncing erratically when switching between input views. One time I couldn't get the layout to work with various image aspect ratios in a horizontal stack (because there was no concept of hugging/compression priorities.)

I also hit random performance issues. And when they hit, it's nearly unrecoverable from a morale perspective. One time I was using SwiftUI to build a level editor for Theseus, and just updating the current square state as the user moved the mouse seemed like it was causing the entire app to redraw every single view on the screen. I'm 100% sure that was my fault, but the fact that the framework allowed me to shoot myself in the foot like that seemed like it should take a bit of the blame.

Anyway, the main takeaway is that I really love coding anonymous view hierarchies with reactive semantics, and I love being able to cleanly isolate the business logic I/O in its own testable class. So I made this library to brings both of those to UIKit (so I can keep everything else that UIKit does better than SwiftUI.)

Jason