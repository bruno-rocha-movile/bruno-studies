import Foundation
import UIKit

class Heap<T: Comparable> {

    typealias Comparator = (T,T) -> Bool

    var elements: [T]
    let priority: Comparator

    init(elements: [T], priority: @escaping Comparator) {
        self.priority = priority
        self.elements = elements
        for i in stride(from: (count / 2) - 1, to: -1, by: -1) {
            siftDown(i)
        }
    }

    var isEmpty: Bool {
        return elements.isEmpty
    }

    var count: Int {
        return elements.count
    }

    var first: T? {
        return elements.first
    }

    func leftChildIndex(of index: Int) -> Int {
        return (2 * index) + 1
    }

    func rightChild(of index: Int) -> Int {
        return (2 * index) + 2
    }

    func parentIndex(of index: Int) -> Int {
        return (index - 1) / 2
    }

    func isHigherPriority(_ a: Int, _ b: Int) -> Bool {
        return priority(elements[a], elements[b])
    }

    func highestPriorityIndex(of index: Int) -> Int {
        let left = highestPriorityIndex(of: index, and: leftChildIndex(of: index))
        let right = highestPriorityIndex(of: index, and: rightChild(of: index))
        return highestPriorityIndex(of: left, and: right)
    }

    func highestPriorityIndex(of parent: Int, and child: Int) -> Int {
        guard child < count else {
            return parent
        }
        guard isHigherPriority(child, parent) else {
            return parent
        }
        return child
    }

    func enqueue(_ element: T) {
        elements.append(element)
        siftUp(count - 1)
    }

    func siftUp(_ i: Int) {
        let parent = parentIndex(of: i)
        guard parent >= 0 else {
            return
        }
        guard isHigherPriority(i, parent) else {
            return
        }
        swap(i, parent)
        siftUp(parent)
    }

    func dequeue() -> T? {
        return remove(at: 0)
    }

    func remove(at i: Int) -> T? {
        swap(i, count - 1)
        let element = elements.popLast()
        siftDown(i)
        return element
    }

    fileprivate func swap(_ i: Int, _ j: Int) {
        (elements[i], elements[j]) = (elements[j], elements[i])
    }

    func siftDown(_ i: Int) {
        let indexToSwap = highestPriorityIndex(of: i)
        guard indexToSwap != i else {
            return
        }
        swap(indexToSwap, i)
        siftDown(indexToSwap)
    }
}
