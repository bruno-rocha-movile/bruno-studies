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
    
    func sibling() -> Node? {
        guard self.parent != nil else {
            return nil
        }
        if self === self.parent.left {
            return self.parent.right
        } else {
            return self.parent.left
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
        balanceIfNeeded(insertedNode: insertedNode)
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
    
    private func balanceIfNeeded(insertedNode insertedNode: Node) {
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
    
    func delete(x: Int) {
        guard let toDel = search(x) else {
            return
        }
        deleteNode(toDel)
    }
    
    //Function call for removing a node
    private func deleteNode(toDel: Node!) {
        var toDel = toDel
        //case for if todel is the only node in the tree
        if toDel.left === nil && toDel.right === nil && toDel.parent === nil {
            toDel = nil
            self.root = nil
            return
        }
        //case for if toDell is a red node w/ no children
        if toDel.left === nil && toDel.right === nil && toDel.color == .Red {
            if toDel!.parent.left === toDel! {
                toDel!.parent.left = nil
                toDel = nil
            } else if toDel!.parent === nil {
                toDel = nil
            } else {
                toDel?.parent.right = nil
                toDel = nil
            }
            return
        }
        //case for toDel having two children
        if toDel!.left !== nil && toDel!.right !== nil {
            let pred = maximum(toDel!.left!)
            toDel!.value = pred.value
            toDel! = pred
        }
        //case for toDel having one child
        var child: Node? = nil
        if toDel!.right === nil {
            child = toDel!.left
        } else {
            child = toDel!.right
        }
        if toDel.color == .Black && child !== nil {
            toDel!.color = child!.color
            checkDeleteCase1(toDel)
        }
        if child !== nil {
            replaceNode(toDel!, n2: child!)
            if toDel.parent === nil && child !== nil {
                child?.color = .Black
            }
        }
        if toDel!.parent.left === toDel! {
            toDel!.parent.left = nil
            toDel = nil
            return
        } else if toDel!.parent === nil {
            toDel = nil
            return
        } else {
            toDel?.parent.right = nil
            toDel = nil
            return
        }
    }
    
    private func maximum(rootnode: Node) -> Node {
        var rootNode = rootnode
        while rootNode.right !== nil {
            rootNode = rootNode.right
        }
        return rootNode
    }
    
    private func replaceNode(n1: Node, n2: Node) {
        let temp = n1.value
        let temp_color = n1.color
        n1.value = n2.value
        n1.color = n2.color
        n2.value = temp
        n2.color = temp_color
    }
    
    private func checkDeleteCase1(deleted: Node) {
        guard deleted.parent != nil else {
            return
        }
        checkDeleteCase2(deleted)
    }
    
    private func checkDeleteCase2(deleted: Node) {
        guard let s = deleted.sibling() else {
            return
        }
        guard s.color == .Red else  {
            return
        }
        deleted.parent.color = .Red
        s.color = .Black
        if deleted === deleted.parent.left {
            rotateLeft(deleted.parent)
        } else {
            rotateRight(deleted.parent)
        }
        checkDeleteCase3(deleted)
    }
    
    private func checkDeleteCase3(deleted: Node) {
        guard let s = deleted.sibling() else {
            return
        }
        if s.parent.color == .Red && s.color == .Black && s.left.color == .Black && s.right.color == .Black {
            s.color = .Red
            checkDeleteCase1(deleted.parent)
        } else {
            checkDeleteCase4(deleted)
        }
    }
    
    private func checkDeleteCase4(deleted: Node) {
        guard let s = deleted.sibling() else {
            return
        }
        if deleted.parent.color == .Red && s.color == .Black && s.left.color == .Black && s.right.color == .Black {
            s.color = .Red
            deleted.parent.color = .Black
        } else {
            checkDeleteCase5(deleted)
        }
    }
    
    private func checkDeleteCase5(deleted: Node) {
        guard let s = deleted.sibling() else {
            return
        }
        if s.color == .Black {
            if deleted === deleted.parent.left && s.right.color == .Black && s.left.color == .Red {
                s.color = .Red
                s.left.color = .Black
                rotateRight(s)
            } else if deleted === deleted.parent.right && s.left.color == .Black && s.right.color == .Red {
                s.color = .Red
                s.right.color = .Black
                rotateLeft(s)
            }
        }
        checkDeleteCase6(deleted)
    }
    
    private func checkDeleteCase6(deleted: Node) {
        guard let s = deleted.sibling() else {
            return
        }
        s.color = deleted.parent.color
        deleted.parent.color = .Black
        if deleted === deleted.parent.left {
            s.right.color = .Black
            rotateLeft(deleted.parent)
        } else {
            s.left.color = .Black
            rotateRight(deleted.parent)
        }
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
tree.delete(14)
tree.root?.draw()
print("================")
print("Searching for 11")
let eleven = tree.search(11)

//AVL tree

//One of the oldest, most well known and most popular tree data structure. It saves additional height information in each node and re balances tree if height of one node is higher than its sibling by 2. That keeps tree rigidly balanced so search is extremely fast on AVL tree. However that comes with a cost of rebalancing and that can make insert/delete operations slightly more expensive than other trees.

//Red-Black tree

//Most widely used self balancing binary search tree. It also saves additional information on nodes (black node or red node) and preserves tree balance based on certain rules about how nodes are colored. It can be less balanced than AVL tree (which means slower search) but with more efficient inserts and deletes. Also because only two colors required, Red-Black tree needs only one bit of additional information per node. All of this makes it most popular choice for general use cases.

//Spacegoat tree
//Doesn't save additional data on the nodes, so it uses less memory. Uses a parameter called "alpha" to determine different levels of balance throughout the tree. Not really better at anything else though

//Splay tree
//This tree performs tree rotations and brings element up to the top. It means that recently accessed elements are always near the top, so it's interesting for cases like cache implementations. However additional rotations on search adds additional overhead and if each element is as likely to be searched then splaying doesn’t do that much good.

//Search is faster on AVL because it's better balanced than the RB tree, but insertion/deletion is faster on the RB because of it's balancing rules based on the node's color.
//First choice for BST is a Red-Black tree as it is most universal data structure. However if your tree will be used mostly for search then take a look at AVL tree. If mostly same elements are retrieved again and again then Splay tree can be even better.

//: [Next](@next)
