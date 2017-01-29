//: [Previous](@previous)

import Foundation

//****************************
//****************************
//****************************
//****************************
//Queue

class Node<T> {
    var value: T?
    var next: Node?
    init(value: T) {
        self.value = value
    }
}

public class Queue<T> {
    typealias Element = T
    var first: Node<Element>? {
        didSet {
            if first == nil {
                last = nil
            }
        }
    }
    var last: Node<Element>?
    var isEmpty: Bool {
        return first == nil
    }
    
    func enqueue(_ value: Element) {
        guard !self.isEmpty else {
            first = Node<Element>(value: value)
            last = first
            return
        }
        self.last?.next = Node<Element>(value: value)
        self.last = self.last?.next
    }
    
    func dequeue() -> Element? {
        let removedItem = first
        first = first?.next
        return removedItem?.value
    }
    
    func printQueue() {
        var current: Node? = self.first
        print("---------------")
        while current != nil && current?.value != nil {
            print("The item is \(current!.value!)")
            current = current!.next
        }
    }
}

//****************************
//****************************
//****************************
//****************************
//****************************
//****************************
//****************************
//****************************
//****************************
//****************************
//****************************
//****************************

public class Vertex: Hashable {
    public var data: String
    public let index: Int
    public var edges: [Edge]
    
    //BFS properties
    var visited = false
    var distance: Float? = nil
    
    init(data: String, index: Int) {
        self.data = data
        self.index = index
        edges = []
    }
    
    public var hashValue:Int {
        get {
            return data.hashValue
        }
    }
    
    public static func == (lhs:Vertex, rhs:Vertex) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

public class Edge {
    public let from: Vertex
    public let to: Vertex
    public let weight: Float?
    
    init(from: Vertex, to: Vertex, weight: Float?) {
        self.from = from
        self.to = to
        self.weight = weight
    }
}

class Graph {
    //Adjacency list
    var vertices: [Vertex] = []
    
    var duplicated: Graph {
        let graph = Graph()
        for vertex in self.vertices {
            let newVertex = Vertex(data: vertex.data, index: vertex.index)
            graph.vertices.append(newVertex)
        }
        for vertex in self.vertices {
            for edge in vertex.edges {
                graph.createDirectedEdge(between: graph.vertices[edge.from.index], and: graph.vertices[edge.to.index], weight: edge.weight)
            }
        }
        return graph
    }
    
    func createVertex(data: String) -> Vertex {
        if let duplicateVertex = checkIfVertexExists(data: data) {
            return duplicateVertex
        }
        let vertex = Vertex(data: data, index: vertices.count)
        vertices.append(vertex)
        return vertex
    }
    
    func checkIfVertexExists(data: String) -> Vertex? {
        let filteredVertices = vertices.filter { return $0.data == data }
        return filteredVertices.first
    }
    
    func createDirectedEdge(between v1: Vertex, and v2: Vertex, weight: Float? = nil) {
        let edge = Edge(from: v1, to: v2, weight: weight)
        v1.edges.append(edge)
    }
    
    func createUndirectedEdge(between v1: Vertex, and v2: Vertex, weight: Float? = nil) {
        createDirectedEdge(between: v1, and: v2, weight: weight)
        createDirectedEdge(between: v2, and: v1, weight: weight)
    }
    
    //BreadthFirstSearch that adds distance data to the vertices and calculates the minimum spanning tree -> minimum amount of edges needed to get to every vertex in the graph.
    func breadthFirstSearchShortestDistanceMinimumSpanningTree(source: Vertex) -> Graph {
        
        let graph = self.duplicated
        let sourceInClonedGraph = graph.vertices.filter{return $0.data == source.data}.first!
        
        let queue = Queue<Vertex>()
        queue.enqueue(sourceInClonedGraph)
        sourceInClonedGraph.visited = true
        sourceInClonedGraph.distance = 0
        while let vertex = queue.dequeue() {
            for edge in vertex.edges {
                let neighborVertex = edge.to
                if neighborVertex.visited == false {
                    queue.enqueue(neighborVertex)
                    neighborVertex.distance = vertex.distance! + 1
                    neighborVertex.visited = true
                } else {
                    let indexOfEdge = (vertex.edges.index{$0 === edge})!
                    vertex.edges.remove(at: indexOfEdge)
                }
            }
        }
        return graph
    }
    
    //Better at finding components on a sparse graph
    //Not here: Can be used to find bridges
    func depthFirstSearch(source: Vertex) -> [String] {
        var exploredVertices = [source.data]
        source.visited = true
        for edge in source.edges {
            if edge.to.visited == false {
                exploredVertices += depthFirstSearch(source: edge.to)
            }
        }
        return exploredVertices
    }
    
    //O([m+n]log n)
    func djikstra(source src: Vertex, target tgt: Vertex) -> [String] {
        
        let graph = self.duplicated
        let source = graph.vertices.filter{return $0.data == src.data}.first!
        let target = graph.vertices.filter{return $0.data == tgt.data}.first!
        
        var heap: [Vertex] = [source]
        var heapSize: Int = 1
        var heapIndex: [Vertex:Int] = [:]

        var previous: [Vertex:Vertex] = [:]
        
        func vertexWithSmallerDistance() -> Vertex {
            let smallestDistanceVertex: Vertex = heap.first!
            if heapSize > 1 {
                (heap[heapSize - 1], heap[0]) = (heap[0], heap[heapSize - 1])
                (heapIndex[heap[0]], heapIndex[heap[heapSize - 1]]) = (heapIndex[heap[heapSize - 1]], heapIndex[heap[0]])
            }
            heapSize -= 1
            shiftDown(valueAtIndex: 0)
            return smallestDistanceVertex
        }
        
        func shiftDown(valueAtIndex index: Int) {
            guard heapSize > 1 else {
                return
            }
            let leftChildIndex = 2 * index + 1
            let rightChildIndex = 2 * index + 2
            var indexToSwap = index
            if leftChildIndex <= heapSize - 1 && heap[indexToSwap].distance! > heap[leftChildIndex].distance! {
                indexToSwap = leftChildIndex
            }
            if rightChildIndex <= heapSize - 1 && heap[indexToSwap].distance! > heap[rightChildIndex].distance! {
                indexToSwap = rightChildIndex
            }
            guard index != indexToSwap else {
                return
            }
            (heap[index], heap[indexToSwap]) = (heap[indexToSwap], heap[index])
            (heapIndex[heap[index]], heapIndex[heap[indexToSwap]]) = (heapIndex[heap[indexToSwap]],heapIndex[heap[index]])
            shiftDown(valueAtIndex: indexToSwap)
        }
        
        func shiftUp(vertex: Vertex) {
            let index = heapIndex[vertex]!
            let parentIndex = (index - 1) / 2
            guard parentIndex >= 0 else {
                return
            }
            if heap[parentIndex].distance! > heap[index].distance! {
                (heap[parentIndex], heap[index]) = (heap[index], heap[parentIndex])
                (heapIndex[heap[parentIndex]], heapIndex[heap[index]]) = (heapIndex[heap[index]], heapIndex[heap[parentIndex]])
                shiftUp(vertex: vertex)
            }
        }
        
        func path() -> [String] {
            var path: [String] = [target.data]
            var prev = previous[target]
            while prev != nil {
                path.insert(prev!.data, at: 0)
                prev = previous[prev!]
            }
            return path
        }

        while heapSize > 0 {
            let vertex = vertexWithSmallerDistance()
            /*if vertex.data == target.data {
                return path()
            }*/
            vertex.visited = true
            for edge in vertex.edges {
                let neighbor = edge.to
                guard neighbor.visited == false else {
                    continue
                }
                let totalDist = (vertex.distance ?? 0) + edge.weight!
                if neighbor.distance == nil || totalDist < neighbor.distance! {
                    neighbor.distance = totalDist
                    previous[neighbor] = vertex
                    if heapIndex[neighbor] == nil {
                        heap.insert(neighbor, at: heapSize)
                        heapIndex[neighbor] = heapSize
                        heapSize += 1
                    }
                    shiftUp(vertex: neighbor)
                }
            }
        }
        
        return path()
    }
}

let graph = Graph()

let a = graph.createVertex(data: "a")
let b = graph.createVertex(data: "b")
let c = graph.createVertex(data: "c")
let d = graph.createVertex(data: "d")
let e = graph.createVertex(data: "e")
let f = graph.createVertex(data: "f")
graph.createUndirectedEdge(between: a, and: b, weight: 7)
graph.createUndirectedEdge(between: a, and: c, weight: 9)
graph.createUndirectedEdge(between: c, and: d, weight: 11)
graph.createUndirectedEdge(between: d, and: e, weight: 6)
graph.createUndirectedEdge(between: e, and: f, weight: 9)
graph.createUndirectedEdge(between: f, and: a, weight: 14)
graph.createUndirectedEdge(between: b, and: c, weight: 10)
graph.createUndirectedEdge(between: b, and: d, weight: 15)
graph.createUndirectedEdge(between: c, and: f, weight: 2)

//This operation ignores weight
let distanceGraphTree = graph.breadthFirstSearchShortestDistanceMinimumSpanningTree(source: a)

let depthSearch = graph.depthFirstSearch(source: a)

let djikstra = graph.djikstra(source: a, target: e)

//: [Next](@next)
