//: [Previous](@previous)

import Foundation

func readLine() -> String? {
    return nil
}

////

class Node {
    let value: Int
    var next: Node? = nil

    init(value: Int, next: Node? = nil) {
        self.value = value
        self.next = next
    }
}

class Stack {

    var head: Node? = nil

    func push(node: Node) {
        if head == nil {
            head = node
        } else {
            node.next = head
            head = node
        }
    }

    func pop() -> Node? {
        let toReturn = head
        head = head?.next
        return toReturn
    }

    func fillFrom(stack: Stack) {
        while let node = stack.pop() {
            push(node: node)
        }
    }
}
