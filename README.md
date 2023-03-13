# Turbo iOS using SwiftUI

This is an initial stab at replicating the demo app for Turbo iOS, but using SwiftUI.



I think that if I understood Swift's type system better, `TurboNavigationHelper#stack` could be replaced with an object that is like `NavigationPath`. What this would hopefully mean is that you could have a type-erased array of `Hashable` object that you could still have the functionality of `appendOrPopTo`, but then you wouldn't need `NavigationDatum`. Instead, you could have as bunch of `navigationDestination` calls for the different specific types of data that could be in that array.
