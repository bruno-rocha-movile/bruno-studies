//: [Previous](@previous)

enum TreeColor: String {
    case Black = "BCK"
    case Red = "RD"
}

class Node {
    var value: Int?
    var left: Node!
    var right: Node!
    var color: TreeColor
    var parent: Node!
    
    init(value: Int) {
        self.value = value
        self.left = nil
        self.right = nil
        self.parent = nil
        self.color = .Red
    }
    
    func grandparent() -> Node? {
        guard let parent = self.parent else {
            return nil
        }
        return parent.parent
    }
    
    func uncle() -> Node? {
        guard let grandparent = self.grandparent() else {
            return nil
        }
        if self.parent === grandparent.left {
            return grandparent.right
        } else {
            return grandparent.left
        }
    }
}

class Tree {
    var root: Node!
    
    init(value: Int) {
        self.root = Node(value: value)
        self.root.color = .Black
    }
    
    func insert(value: Int) {
        guard let insertedNode = insert(value, parent: root) else {
            return
        }
        balanceIfNeeded(insertedNode)
    }
    
    private func insert(value: Int, parent: Node) -> Node? {
        if self.root == nil {
            self.root = Node(value: value)
            return self.root
        } else if value < parent.value {
            if let left = parent.left {
                return insert(value, parent: left)
            } else {
                parent.left = Node(value: value)
                parent.left?.parent = parent
                return parent.left!
            }
        } else if value > parent.value {
            if let right = parent.right {
                return insert(value, parent: right)
            } else {
                parent.right = Node(value: value)
                parent.right?.parent = parent
                return parent.right!
            }
        } else {
            return nil
        }
    }
    
    private func balanceIfNeeded(insertedNode: Node) {
        checkCase1(insertedNode)
    }
    
    //Caso 1: Root sempre deve ser negro
    private func checkCase1(inserted: Node) {
        guard inserted === self.root else {
            return checkCase2(inserted)
        }
        self.root.color = .Black
    }
    
    //Caso 2: O pai do node inserido deve ser negro.
    private func checkCase2(inserted: Node) {
        guard inserted.parent.color == .Black else {
            return checkCase3(inserted)
        }
    }
    
    //Caso 3: Se o pai e tio são vermelhos, os dois devem virar negros, enquanto o avô vira vermelho.
    private func checkCase3(inserted: Node) {
        guard let uncle = inserted.uncle() where uncle.color == .Red else {
            return checkCase4(inserted)
        }
        inserted.parent.color = .Black
        uncle.color = .Black
        guard let grandparent = inserted.grandparent() else {
            //This should never be reached.
            return fatalError()
        }
        grandparent.color = .Red
        checkCase1(grandparent)
    }
    
    //Caso 4: "The parent P is red but the uncle U is black; also, the current node N is the right child of P, and P in turn is the left child of its parent G. In this case, a left rotation on P that switches the roles of the current node N and its parent P can be performed;"
    private func checkCase4(inserted: Node) {
        var inserted = inserted
        guard let parent = inserted.parent, grandparent = inserted.grandparent() else {
            //This should never be reached.
            return fatalError()
        }
        if inserted === inserted.parent.right && parent === grandparent.left {
            rotateRight(parent)
            inserted = inserted.left
        } else if inserted === parent.left && parent === grandparent.right {
            rotateLeft(parent)
            inserted = inserted.right
        }
        checkCase5(inserted)
    }
    
    //Caso 5: O pai é vermelho mas o tio é negro?
    private func checkCase5(inserted: Node) {
        guard let parent = inserted.parent, grandparent = inserted.grandparent() else {
            //This should never be reached.
            return fatalError()
        }
        parent.color = .Black
        grandparent.color = .Red
        if inserted === parent.left {
            rotateRight(grandparent)
        } else {
            rotateLeft(grandparent)
        }
    }
    
    private func rotateLeft(node: Node) {
        let newRoot = node.right
        node.right = newRoot.left
        if newRoot.left !== nil {
            newRoot.left.parent = node
        }
        newRoot.parent = node.parent
        if node.parent === nil {
            root = newRoot
        } else if node === node.parent.left {
            node.parent.left = newRoot
        } else {
            node.parent.right = newRoot
        }
        newRoot.left = node
        node.parent = newRoot
    }
    
    private func rotateRight(node: Node) {
        let newRoot = node.left
        node.left = newRoot.right
        if newRoot.right !== nil {
            newRoot.right.parent = node
        }
        newRoot.parent = node.parent
        if node.parent === nil {
            root = newRoot
        } else if node === node.parent.right {
            node.parent.right = newRoot
        } else {
            node.parent.left = newRoot
        }
        newRoot.right = node
        node.parent = newRoot
    }
    
    func search(value: Int) -> Node? {
        return search(node: root, value: value)
    }
    
    private func search(node node: Node, value: Int) -> Node? {
        if node.value == value {
            print("Found it.")
            return node
        } else if value < node.value && node.left?.value != nil {
            return search(node: node.left, value: value)
        } else if value > node.value && node.right?.value != nil {
            return search(node: node.right, value: value)
        } else {
            print("Value not found")
            return nil
        }
    }
}

extension Node {
    func draw() {
        right?.draw("", " |  ", "    ")
        print("\(value!)(\(color.rawValue))")
        left?.draw("", "    ", " |  ")
    }
    
    func draw(indent: String, _ leftIndent: String, _ rightIndent: String) {
        right?.draw(rightIndent, rightIndent + " |  ", rightIndent + "    ")
        print(indent + " +- " + "\(value!)(\(color.rawValue))")
        left?.draw(leftIndent, leftIndent + "    ", leftIndent + " |  ")
    }
}

let tree = Tree(value: 8)
tree.insert(2)
tree.insert(10)
tree.insert(9)
tree.insert(11)
tree.insert(1)
tree.insert(7)
tree.insert(12)
tree.insert(13)
tree.insert(14)
tree.root?.draw()
print("================")
print("Searching for 11")
let eleven = tree.search(11)

//: [Next](@next)
