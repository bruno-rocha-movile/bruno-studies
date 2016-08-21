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
    
    //0(n log2 n)
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
}

let array:[Int] = [2,5,7,3,9,1,8,10,4,6]

array.insertionSort
array.selectionSort
array.bubbleSort
array.combSort

array.quickSort
array.mergeSort

//: [Next](@next)
