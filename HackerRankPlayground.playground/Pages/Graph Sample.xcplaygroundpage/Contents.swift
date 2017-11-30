import Foundation

class Heap<T: Comparable> {

    typealias Comparator = (T,T) -> Bool

    var elements: [T]
    let priority: Comparator

    init(elements: [T], priority: @escaping Comparator) {
        self.priority = priority
        self.elements = elements
        for i in stride(from: (count / 2) - 1, to: 0, by: -1) {
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
        guard isEmpty == false else {
            return nil
        }
        swap(0, count - 1)
        let element = elements[count - 1]
        siftDown(0)
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

public struct Vertex<T>: Comparable where T: Comparable {

    public var data: T
    public let index: Int
}

extension Vertex: CustomStringConvertible {
    public var description: String {
        return "\(index): \(data)"
    }
}

extension Vertex: Hashable {
    public var hashValue: Int {
        return "\(data)\(index)".hashValue
    }

}

public func ==<T>(lhs: Vertex<T>, rhs: Vertex<T>) -> Bool {
    guard lhs.index == rhs.index else {
        return false
    }
    guard lhs.data == rhs.data else {
        return false
    }
    return true
}

public func ><T>(lhs: Vertex<T>, rhs: Vertex<T>) -> Bool {
    return lhs.data > rhs.data
}

public func <<T>(lhs: Vertex<T>, rhs: Vertex<T>) -> Bool {
    return lhs.data < rhs.data
}

public struct Edge<T>: Equatable where T: Comparable {
    public let from: Vertex<T>
    public let to: Vertex<T>
    public let weight: Double?
}

extension Edge: Hashable {
    public var hashValue: Int {
        var string = "\(from.description)\(to.description)"
        if weight != nil {
            string.append("\(weight!)")
        }
        return string.hashValue
    }
}

public func ==<T>(lhs: Edge<T>, rhs: Edge<T>) -> Bool {
    guard lhs.from == rhs.from else {
        return false
    }
    guard lhs.to == rhs.to else {
        return false
    }
    guard lhs.weight == rhs.weight else {
        return false
    }
    return true
}

private class EdgeList<T> where T: Comparable {

    var vertex: Vertex<T>
    var edges: [Edge<T>]?

    init(vertex: Vertex<T>) {
        self.vertex = vertex
    }

    func addEdge(_ edge: Edge<T>) {
        edges?.append(edge)
    }

}

open class AdjacencyListGraph<T> where T: Comparable {

    fileprivate var adjacencyList: [EdgeList<T>] = []

    open var vertices: [Vertex<T>] {
        return adjacencyList.map { $0.vertex }
    }

    open var edges: [Edge<T>] {
        return adjacencyList.flatMap { $0.edges }.flatMap { $0 }
    }

    open func createVertex(_ data: T) -> Vertex<T> {
        let vertex = Vertex(data: data, index: adjacencyList.count)
        adjacencyList.append(EdgeList(vertex: vertex))
        return vertex
    }

    open func addDirectedEdge(_ from: Vertex<T>, to: Vertex<T>, withWeight weight: Double? = nil) {
        let edge = Edge(from: from, to: to, weight: weight)
        let edgeList = adjacencyList[from.index]
        if edgeList.edges != nil {
            edgeList.addEdge(edge)
        } else {
            edgeList.edges = [edge]
        }
    }

    open func addUndirectedEdge(_ vertices: (Vertex<T>, Vertex<T>), withWeight weight: Double? = nil) {
        addDirectedEdge(vertices.0, to: vertices.1, withWeight: weight)
        addDirectedEdge(vertices.1, to: vertices.0, withWeight: weight)
    }

    open func weightFrom(_ sourceVertex: Vertex<T>, to destinationVertex: Vertex<T>) -> Double? {
        guard let edges = adjacencyList[sourceVertex.index].edges else {
            return nil
        }
        for edge: Edge<T> in edges {
            if edge.to == destinationVertex {
                return edge.weight
            }
        }
        return nil
    }

    open func edgesFrom(_ sourceVertex: Vertex<T>) -> [Edge<T>] {
        return adjacencyList[sourceVertex.index].edges ?? []
    }

    open var description: String {
        var rows = [String]()
        for edgeList in adjacencyList {
            guard let edges = edgeList.edges else {
                continue
            }
            var row = [String]()
            for edge in edges {
                var value = "\(edge.to.data)"
                if edge.weight != nil {
                    value = "(\(value): \(edge.weight!))"
                }
                row.append(value)
            }
            rows.append("\(edgeList.vertex.data) -> [\(row.joined(separator: ", "))]")
        }
        return rows.joined(separator: "\n")
    }

    func bfs(source: Vertex<T>) -> [T] {
        var visited = Set<Vertex<T>>()
        visited.insert(source)
        var explored: [T] = [source.data]
        let queue = Queue<Vertex<T>>()
        queue.enqueue(Node(value: source))
        while let vertex = queue.dequeue()?.value {
            for edge in edgesFrom(vertex) {
                let neighbour = edge.to
                guard visited.contains(neighbour) == false else {
                    continue
                }
                queue.enqueue(Node(value: neighbour))
                visited.insert(neighbour)
                explored.append(neighbour.data)
            }
        }
        return explored
    }

    func djikstra(source: Vertex<T>, target: Vertex<T>) -> Int {
        var visited = Set<Vertex<T>>()
        visited.insert(source)
        var distances = [Vertex<T>:Int]()
        let queue = Heap<Vertex<T>>(elements: vertices) {
            return $0.data > $1.data
        }
        queue.enqueue(source)
        while let vertex = queue.dequeue() {
            for edge in edgesFrom(vertex) {
                let neighbour = edge.to
                guard visited.contains(neighbour) == false else {
                    continue
                }
                visited.insert(neighbour)
                let calculatedDistance = (distances[edge.from] ?? 0) + 6
                if distances[neighbour] == nil || calculatedDistance < (distances[neighbour] ?? 0) {
                    distances[neighbour] = calculatedDistance
                }
                if neighbour == target {
                    return distances[neighbour] ?? -1
                }
            }
        }
        return -1
    }
}
