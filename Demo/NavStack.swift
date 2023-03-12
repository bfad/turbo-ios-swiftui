//
//  NavStack.swift
//  Demo
//
//  Created by Brad Lindsay on 3/12/23.
//

typealias NavStack<Element> = Array<Element> where Element: Hashable

// Used by the navigation stack for TurboNavigationHelper
extension NavStack {
    mutating func appendOrPopTo(_ element: Array.Element) {
        if let findex = firstIndex(of: element) {
            removeSubrange(index(after: findex)..<endIndex)
        } else {
            append(element)
        }
    }
    
    mutating func replaceLast(with element: Array.Element) {
        if !isEmpty { removeLast() }
        append(element)
    }
}
