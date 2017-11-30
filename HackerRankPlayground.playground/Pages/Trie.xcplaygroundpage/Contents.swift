//: [Previous](@previous)

import Foundation

class Node {
    var map = [Character: Node]()
    var wordCount = 0

    func add(word: [Character]) {
        wordCount += 1
        var current = self
        for i in 0..<word.count {
            if let node = current.map[word[i]] {
                current = node
                current.wordCount += 1
            } else {
                let node = Node()
                node.wordCount += 1
                current.map[word[i]] = node
                current = node
            }
        }
    }

    func prints(prefix: [Character]) -> Int {
        var i = 0
        var node = map[prefix[i]]
        while i < prefix.count - 1 {
            i += 1
            guard let n = node else {
                return 0
            }
            node = n.map[prefix[i]]
        }
        return node?.wordCount ?? 0
    }
}

class Trie {
    var root = Node()

    func add(word: String) {
        root.add(word: Array(word.characters))
    }

    func prints(prefix: String) {
        print(root.prints(prefix: Array(prefix.characters)))
    }
}
