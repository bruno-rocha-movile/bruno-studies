//: [Previous](@previous)

import Foundation

class Node<T> {
    var value: T?
    var previous: Node?
    init(value: T) {
        self.value = value
    }
}

public class Stack<T> {
    typealias Element = T
    var first: Node<Element>?
    var isEmpty: Bool {
        return first == nil
    }
    
    func append(value: Element) {
        guard !self.isEmpty else {
            first = Node<Element>(value: value)
            return
        }
        let node: Node<T> = Node<Element>(value: value)
        node.previous = first
        first = node
    }
    
    func destack() -> Element? {
        let removedItem = first
        first = first?.previous
        return removedItem?.value
    }
    
    func printStack() {
        var current: Node? = self.first
        print("---------------")
        while current != nil && current?.value != nil {
            print("The item is \(current!.value!)")
            current = current!.previous
        }
    }
}

var stack = Stack<Int>()
stack.append(100)
stack.append(200)
stack.append(300)
stack.append(400)
stack.printStack()
stack.destack()
stack.destack()
stack.printStack()

//: [Next](@next)
