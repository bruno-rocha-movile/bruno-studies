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
        //The "indexToThrowLesserElement" is now certainly positioned on a position with an element greater or equal than our pivot, with lesser elements to the left, and greater elements to the right. Swap the pivot with this position to end the partitioning for this array.
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
    
    //********
    //************
    //***************
    //*****************
    
    //0(n log n)
    var mergeSort: [Int] {
        guard let input = self as? [Int] else {
            return [Int]()
        }
        return mergeSort(input)
    }
    
    private func mergeSort(_ input: [Int]) -> [Int] {
        guard input.count > 1 else {
            return input
        }
        let half = input.count / 2
        let leftArray = mergeSort([Int](input.prefix(upTo: half)))
        let rightArray = mergeSort([Int](input.suffix(from: half)))
        return merge(leftArray, with: rightArray)
    }
    
    private func merge(_ leftArray: [Int], with rightArray: [Int]) -> [Int] {
        var leftIndex = 0
        var rightIndex = 0
        var orderedArray = [Int]()
        
        // From these two arrays, compare their elements, and start adding these elements on the orderedArray, until one of the arrays end
        
        func oneOfTheArraysHasntEnded() -> Bool {
            return leftIndex < leftArray.count && rightIndex < rightArray.count
        }
        
        while oneOfTheArraysHasntEnded() {
            if leftArray[leftIndex] < rightArray[rightIndex] {
                orderedArray.append(leftArray[leftIndex])
                leftIndex += 1
            } else if leftArray[leftIndex] > rightArray[rightIndex] {
                orderedArray.append(rightArray[rightIndex])
                rightIndex += 1
            } else {
                orderedArray.append(leftArray[leftIndex])
                leftIndex += 1
                orderedArray.append(rightArray[rightIndex])
                rightIndex += 1
            }
        }
        
        //If we are here, it means that one of the arrays doesn't have more elements to compare. So we just get whatever array is left, and append his elements to the ordered array.
        while leftIndex < leftArray.count {
            orderedArray.append(leftArray[leftIndex])
            leftIndex += 1
        }
        
        while rightIndex < rightArray.count {
            orderedArray.append(rightArray[rightIndex])
            rightIndex += 1
        }
        
        return orderedArray
    }
    
    var heapSort: [Int] {
        guard var input = self as? [Int] else {
            return [Int]()
        }
        maxHeapify(&input)
        heapSort(&input, lastElementIndex: input.count - 1)
        return input
    }
    
    func maxHeapify(_ input: inout [Int]) {
        //maxheap: parent elements is always bigger | minheap: parent is smaller. I'm doing a maxheap
        for i in 0..<input.count {
            //send elements the heap chain until it's bigger than it's children and smaller than it's parent
            shiftUp(valueAtIndex: i, at: &input)
        }

    }
    
    func shiftUp(valueAtIndex index: Int, at heap: inout [Int]) {
        let parentIndex = (index - 1) / 2
        guard parentIndex >= 0 else {
            return
        }
        if heap[parentIndex] < heap[index] {
            (heap[parentIndex], heap[index]) = (heap[index], heap[parentIndex])
            shiftUp(valueAtIndex: parentIndex, at: &heap)
        }
    }
    
    func shiftDown(valueAtIndex index: Int, at heap: inout [Int], heapSize: Int) {
        let leftChildIndex = 2 * index + 1
        let rightChildIndex = 2 * index + 2
        var indexToSwap = index
        if leftChildIndex <= heapSize && heap[indexToSwap] < heap[leftChildIndex] {
            indexToSwap = leftChildIndex
        }
        if rightChildIndex <= heapSize && heap[indexToSwap] < heap[rightChildIndex] {
            indexToSwap = rightChildIndex
        }
        guard index != indexToSwap else {
            return
        }
        (heap[index], heap[indexToSwap]) = (heap[indexToSwap], heap[index])
        shiftDown(valueAtIndex: indexToSwap, at: &heap, heapSize: heapSize)
    }
    
    func heapSort(_ heap: inout [Int], lastElementIndex: Int) {
        guard lastElementIndex > 0 else {
            return
        }
        //the first element of the heap is the biggest element of the (current) array. swap it with the (current) last position and send the new first element down the heap
        (heap[0], heap[lastElementIndex]) = (heap[lastElementIndex], heap[0])
        let newLastElementIndex = lastElementIndex - 1
        shiftDown(valueAtIndex: 0, at: &heap, heapSize: newLastElementIndex)
        heapSort(&heap, lastElementIndex: newLastElementIndex)
    }
}

let array:[Int] = [64,2,12,5,7,3,48,9,1,8,10,4,6]

array.quickSort
array.quickSortSlow
array.mergeSort
array.heapSort

//: [Next](@next)
