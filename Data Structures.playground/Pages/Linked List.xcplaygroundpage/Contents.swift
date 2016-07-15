//: Playground - noun: a place where people can play

import UIKit

class Node<T: Equatable> {
    var value: T? = nil
    var next: Node? = nil
    init(value: T) {
        self.value = value
    }
}

class LinkedList<T: Equatable> {
    typealias Element = T
    var root: Node<Element>? {
        didSet {
            if root == nil {
                lastNode = nil
            }
        }
    }
    var lastNode: Node<Element>?
    var isEmpty: Bool {
        return root?.value == nil ? true : false
    }
    
    func add(value: Element) {
        guard !self.isEmpty else {
            root = Node<Element>(value: value)
            lastNode = root
            return
        }
        let newNode = Node<Element>(value: value)
        self.lastNode?.next = newNode
        self.lastNode = newNode
    }
    
    func remove(value: Element) {
        var node = root, previousNode = Node<Element>?()
        while node?.value != value && node?.next != nil {
            previousNode = node
            node = node?.next
        }
        guard node?.value == value else {
            return
        }
        guard root?.value != value else {
            root = root?.next
            return
        }
        previousNode?.next = node?.next
    }
    
    func printList() {
        var current: Node? = self.root
        print("---------------")
        while current != nil && current?.value != nil {
            print("The item is \(current!.value!)")
            current = current!.next
        }
    }
}

var myList = LinkedList<Int>()
myList.add(100)
myList.add(200)
myList.add(300)
myList.add(400)
myList.remove(100)
myList.remove(300)
myList.remove(400)
myList.printList()
