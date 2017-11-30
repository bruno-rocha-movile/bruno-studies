//: [Previous](@previous)

class Tree<T: Comparable> {
    var value: T?
    var left: Tree?
    var right: Tree?
    
    init(value: T) {
        self.value = value
        self.left = nil
        self.right = nil
    }
    
    func add(value: T) {
        if self.value == nil {
            self.value = value
        } else if value < self.value {
            if self.left == nil {
                self.left = Tree(value: value)
            } else {
                self.left?.add(value)
            }
        } else if value > self.value {
            if self.right == nil {
                self.right = Tree(value: value)
            } else {
                self.right?.add(value)
            }
        } else {
            print("Value already added to the tree.")
        }
    }
}

extension Tree {
    
    func draw() {
        right?.draw("", " |  ", "    ")
        print("\(value!)")
        left?.draw("", "    ", " |  ")
    }
    
    func draw(indent: String, _ leftIndent: String, _ rightIndent: String) {
        right?.draw(rightIndent, rightIndent + " |  ", rightIndent + "    ")
        print(indent + " +- " + "\(value!)")
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

//: [Next](@next)
