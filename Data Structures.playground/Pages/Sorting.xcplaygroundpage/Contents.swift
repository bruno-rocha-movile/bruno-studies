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
    
    //************
    //************
    
    //0(n2) at it's worst, 0(n log n) at it's average case
    var quickSort: [Int] {
        guard var input = self as? [Int] else {
            return [Int]()
        }
        quick(&input, left: 0, right: input.count-1)
        return input
    }
    
    private func quick(inout input: [Int], left: Int, right: Int) {
        if (left < right) {
            let newPivot = partition(&input, pivot: left, right: right);
            quick(&input, left: left, right: newPivot - 1);
            quick(&input, left: newPivot + 1, right: right);
        }
    }
    
    private func partition(inout input: [Int], pivot: Int, right: Int) -> Int {
        let x = input[right]
        var j = pivot - 1
        for i in pivot..<right {
            if x >= input[i] {
                j = j + 1
                let aux = input[j]
                input[j] = input[i]
                input[i] = aux
            }
        }
        input[right] = input[j+1]
        input[j+1] = x
        return j + 1
    }
    
    //************
    //************
    
    //0(n log n)
    var mergeSort: [Int] {
        guard var input = self as? [Int] else {
            return [Int]()
        }
        mergeSort(&input, start: 0, end: input.count-1)
        return input
    }
    
    private func mergeSort(inout input:[Int], start:Int, end:Int) {
        var i = 0, j = 0, k = 0
        guard start != end else {
            return
        }
        let half = (start + end) / 2
        mergeSort(&input, start: start, end: half)
        mergeSort(&input, start: half + 1, end: end)
        i = start;
        j = half + 1;
        var auxArray = Array<Int>(count: end - start + 1, repeatedValue: 0)
        while(i < half + 1 || j  < end + 1) {
            if (i == half + 1 ) {
                auxArray[k] = input[j];
                j += 1;
                k += 1;
            }
            else {
                if (j == end + 1) {
                    auxArray[k] = input[i];
                    i += 1;
                    k += 1;
                }
                else {
                    if (input[i] < input[j]) {
                        auxArray[k] = input[i];
                        i += 1;
                        k += 1;
                    }
                    else {
                        auxArray[k] = input[j];
                        j += 1;
                        k += 1;
                    }
                }
            }
            
        }
        for l in start...end {
            input[l] = auxArray[l - start];
        }
    }
    
    //************
    //************
    
    //0(n log n)
    var heapSort: [Int] {
        guard var list = self as? [Int] else {
            return [Int]()
        }
        let count = list.count
        heapify(&list, count)
        var end = count - 1
        while end > 0 {
            (list[end], list[0]) = (list[0], list[end])
            end -= 1
            shiftDown(&list, 0, end)
        }
        return list
    }
    
    private func shiftDown(inout list:[Int], _ start:Int, _ end:Int) {
        var root = start
        while root * 2 + 1 <= end {
            let child = root * 2 + 1
            var swap = root
            if list[swap] < list[child] {
                swap = child
            }
            if child + 1 <= end && list[swap] < list[child + 1] {
                swap = child + 1
            }
            if swap == root {
                return
            } else {
                (list[root], list[swap]) = (list[swap], list[root])
                root = swap
            }
        }
    }
    
    private func heapify(inout list:[Int], _ count:Int) {
        var start = (count - 2) / 2
        while start >= 0 {
            shiftDown(&list, start, count - 1)
            start -= 1
        }
    }
}

let array:[Int] = [64,2,12,5,7,3,48,9,1,8,10,4,6]

array.insertionSort
array.selectionSort
array.bubbleSort
array.combSort

array.quickSort
array.mergeSort
array.heapSort

//Quicksort partitions a list into two sublists with all elements less than a “pivot” value in one list and all elements greater than the pivot value in the other then calls itself recursively to sort the sublists.

//Mergesort divides a list equally into 2 sublists and calls itself recursively to sort the sublists. It then “merges” the 2 lists together by removing the smallest element from the sublists and appending it to the final list. This process is repeated until a sublist is empty when the other sublist is appended to the final list.

//Heapsort creates a binary heap out of a list of data then removes the first element in the list and appends it to a final list. It repeats this until the heap is empty.

//Quicksort is the fastest in average, but has some nasty worst behaviors (n2). It may not be used in applications which require a guarantee of response time, unless it is treated as an O(n2) algorithm.

//And if n is large, you should be using heap sort / merge sort, for its guaranteed O(nlog n) time.
//For these two, merge sort is slightly faster, but requires additional memory. It is best used if you are handling external data, like saving in a hard drive.

//: [Next](@next)
