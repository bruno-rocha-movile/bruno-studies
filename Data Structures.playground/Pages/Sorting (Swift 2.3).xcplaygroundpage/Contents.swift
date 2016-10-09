//: [Previous](@previous)

import Foundation

extension Collection where Iterator.Element == Int {
    
    //0(n2) at it's worst, 0(n log n) at it's average case
    //Choose a pivot (I'm getting the right element), and sort elements to the left or right based on this pivot's value. Repeated this process on the 2 new arrays. Rinse and repeat.
    var quickSort: [Int] {
        guard var input = self as? [Int] else {
            return [Int]()
        }
        quick(&input, arrayBeginning: 0, arrayEnd: input.count - 1)
        return input
    }
    
    private func quick(_ input: inout [Int], arrayBeginning: Int, arrayEnd: Int) {
        guard arrayBeginning < arrayEnd else {
            return
        }
        partition(&input, arrayBeginning: arrayBeginning, arrayEnd: arrayEnd)
    }
    
    private func partition(_ input: inout [Int], arrayBeginning: Int, arrayEnd: Int) {
        let pivotIndex = arrayEnd
        let pivot = input[pivotIndex]
        var indexToThrowLesserElement = arrayBeginning
        for j in arrayBeginning..<arrayEnd {
            if input[j] <= pivot {
                //Send the smaller element to the designated index
                (input[indexToThrowLesserElement], input[j]) = (input[j], input[indexToThrowLesserElement])
                //Move the designated index forward
                indexToThrowLesserElement += 1
            }
        }
        //The "indexToThrowLesserElement" is now certainly positioned on a position with an element greater than our pivot, with lesser elements to the left, and greater elements to the right. Swap the pivot with this position to end the partitioning for this array.
        (input[indexToThrowLesserElement], input[pivotIndex]) = (input[pivotIndex], input[indexToThrowLesserElement])
        let pivotsFinalIndex = indexToThrowLesserElement
        //Quick sort the elements to the right of the pivot
        quick(&input, arrayBeginning: arrayBeginning, arrayEnd: pivotsFinalIndex - 1)
        //Quick sort the elements to the left of the pivot
        quick(&input, arrayBeginning: pivotsFinalIndex + 1, arrayEnd: arrayEnd)
    }
    
    //Bonus
    //An easy way to understand quicksort, but slow due to the triple filter
    var quickSortSlow: [Int] {
        guard var input = self as? [Int] else {
            return [Int]()
        }
        partitionSlow(&input)
        return input
    }
    
    private func partitionSlow(_ input: inout [Int]) {
        guard input.count > 1, let pivot = input.last else {
            return
        }
        var lesserElements = input.filter{$0 < pivot}
        let equalElements = input.filter{$0 == pivot}
        var greaterElements = input.filter{$0 > pivot}
        partitionSlow(&lesserElements)
        partitionSlow(&greaterElements)
        input = lesserElements + equalElements + greaterElements
    }
}

let array:[Int] = [64,2,12,5,7,3,48,9,1,8,10,4,6]

array.quickSort
array.quickSortSlow

//: [Next](@next)
