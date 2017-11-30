import Foundation

class Node<T> {
    let value: T
    var next: Node? = nil

    init(value: T, next: Node? = nil) {
        self.value = value
        self.next = next
    }
}

class Queue<T> {

    var head: Node<T>? = nil
    var bottom: Node<T>? = nil

    func enqueue(_ node: Node<T>) {
        if head == nil {
            head = node
        } else {
            bottom?.next = node
        }
        bottom = node
    }

    func dequeue() -> Node<T>? {
        let toReturn = head
        if head?.next == nil {
            bottom = nil
        }
        head = head?.next
        return toReturn
    }
}

let queue = Queue<Int>()

queue.enqueue(Node(value: 1))
queue.enqueue(Node(value: 2))
queue.enqueue(Node(value: 3))

queue.head?.value
queue.bottom?.value
queue.dequeue()
queue.head?.value
queue.bottom?.value
queue.dequeue()
queue.head?.value
queue.bottom?.value
queue.dequeue()
queue.head?.value
queue.bottom?.value
