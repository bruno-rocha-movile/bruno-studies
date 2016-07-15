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
                insert(value, parent: left)
            } else {
                parent.left = Node(value: value)
                parent.left?.parent = parent
                return parent.left!
            }
        } else if value > parent.value {
            if let right = parent.right {
                insert(value, parent: right)
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
tree.root?.draw()
    
  /*  func add(value: T) {
        if self.value == nil {
            self.value = value
            self.color = .Black
        } else if value < self.value {
            if self.left == nil {
                self.left = Tree(value: value)
                self.left!.color = self.color == .Black ? .Red : .Black
                balanceIfNeeded()
            } else {
                self.left?.add(value)
            }
        } else if value > self.value {
            if self.right == nil {
                self.right = Tree(value: value)
                self.right!.color = self.color == .Black ? .Red : .Black
                balanceIfNeeded()
            } else {
                self.right?.add(value)
            }
        } else {
            print("Value already added to the tree.")
        }
    }
    
    private func balanceIfNeeded() {
        
    }
    
    func search(value: T) -> Tree? {
        if self.value == value {
            print("Found it.")
            return self
        } else if value < self.value && self.left?.value != nil {
            return self.left?.search(value)
        } else if value > self.value && self.right?.value != nil {
            return self.right?.search(value)
        } else {
            print("Value not found")
            return nil
        }
    } */
/*
extension Tree {
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
tree.add(2)
tree.add(10)
tree.add(9)
tree.add(11)
tree.add(1)
tree.add(7)
tree.add(12)
tree.add(13)
tree.add(14)
tree.draw()
print("================")
print("Searching for 11")
let eleven = tree.search(11)
 */

//: [Next](@next)
