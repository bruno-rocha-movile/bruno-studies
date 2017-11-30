//: [Previous](@previous)

import Foundation
import UIKit

extension Array where Element: Comparable {
    func binarySearchIndexOf(element: Element) -> Int {
        return binarySearch(element, 0, count - 1)
    }

    func binarySearch(_ element: Element, _ i: Int, _ j: Int) -> Int {
        let middle = (i+j)/2
        let this = self[middle]
        if this == element {
            return middle
        }
        if i == j {
            return element > this ? middle + 1 : middle
        }
        if this > element {
            return binarySearch(element, i, middle)
        } else {
            return binarySearch(element, middle + 1, j)
        }
    }
}
