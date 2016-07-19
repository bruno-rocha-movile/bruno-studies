//: [Previous](@previous)

import Foundation

extension SequenceType where Generator.Element == Int {
    //O(n2) sorts elements to the left
    var insertionSort: [Int] {
        guard var input = self as? [Int] else {
            return [Int]()
        }
        var j, original: Int
        for i in 1..<input.count {
            original = input[i]
            j = i
            while j > 0 && input[j-1] > original {
                input[j] = input[j-1]
                j = j - 1
            }
            input[j] = original
        }
        return input
    }
    
    //O(n2) throws minimum value to the first position of the array
    var selectionSort: [Int] {
        guard var input = self as? [Int] else {
            return [Int]()
        }
        var min, aux: Int
        for i in 0..<input.count {
            min = i
            for j in i+1..<input.count {
                if input[j] < input[min] {
                    min = j
                }
            }
            if min != i {
                aux = input[min]
                input[min] = input[i]
                input[i] = aux
            }
        }
        return input
    }
    
    //O(n2) iterates several times throwing the maximum element to the top
    var bubbleSort: [Int] {
        guard var input = self as? [Int] else {
            return [Int]()
        }
        var aux: Int
        for i in (input.count-1).stride(to: 1, by: -1) {
            for j in 0..<i {
                if input[j] > input[j+1] {
                    aux = input[j]
                    input[j] = input[j+1]
                    input[j+1] = aux
                }
            }
        }
        return input
    }
    
    //O(n2) similar to bubble sort but better
    var combSort: [Int] {
        guard var input = self as? [Int] else {
            return [Int]()
        }
        var gap = Int(Double(input.count) / 1.3)
        var i = 0
        var aux = 0
        while gap > 0 && i != (input.count - 1) {
            i = 0
            while (i + gap) < input.count {
                if input[i] > input[i + gap] {
                    aux = input[i]
                    input[i] = input[i + gap]
                    input[i + gap] = aux
                }
                i = i + 1
            }
            gap = Int(Double(gap) / 1.3)
        }
        return input
    }
}

let array:[Int] = [2,5,7,3,9,1,8,10,4,6]

array.insertionSort
array.selectionSort
array.bubbleSort
array.combSort

//: [Next](@next)
