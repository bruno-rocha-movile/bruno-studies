//: Playground - noun: a place where people can play

import UIKit

func max(_ a: Int, _ b: Int) -> Int {
    return a > b ? a : b
}

func knapSackRECURSIVE(values: [Int], weights: [Int], maxWeight: Int) -> Int {
    func knapSackRECURSIVE(_ values: [Int], _ weights: [Int], _ maxWeight: Int, _ arraySize: Int) -> Int {
        if arraySize == 0 || maxWeight == 0 {
            return 0;
        }
        
        // Can't include item if it's bigger than the knapsack's capacity
        if (weights[arraySize-1] > maxWeight) {
            return knapSackRECURSIVE(values, weights, maxWeight, arraySize-1)
        }
        
        //Each item only has two options: 0 (not included), or 1 (included). Return the max of these two cases.
        else  {
            return max(values[arraySize-1] + knapSackRECURSIVE(values, weights, maxWeight-weights[arraySize-1], arraySize-1), knapSackRECURSIVE(values, weights, maxWeight, arraySize-1))
        }
    }
    return knapSackRECURSIVE(values, weights, maxWeight, values.count)
}

func knapSack(values: [Int], weights: [Int], maxWeight: Int) -> Int {
    func knapSack(_ values: [Int], _ weights: [Int], _ maxWeight: Int, _ arraySize: Int) -> Int {
        // int[arraySize+1][maxWeight+1]
        var table = Array<Array<Int>>(repeating: Array<Int>(repeating: 0, count: maxWeight + 1), count: arraySize + 1)
        for n in 0...arraySize {
            for w in 0...maxWeight {
                let thisItem = n-1
                if (n==0 || w==0) {
                    table[n][w] = 0;
                } else if (weights[thisItem] <= w) {
                    //If the item can be added, the value of this table's position will be the best of these cases: The value of the item, plus whatever the best case is of the remaining weight, or the best case if you don't add it (which is already calculated)
                    table[n][w] = max(values[thisItem] + table[thisItem][w-weights[thisItem]],  table[thisItem][w]);
                } else {
                    //If it can't be added, then the value will be the best case without adding the item
                    table[n][w] = table[thisItem][w];
                }
            }
        }
        return table[arraySize][maxWeight];
    }
    return knapSack(values, weights, maxWeight, values.count)
}

let values = [60, 100, 120]
let weights = [10, 20, 30]
let maxWeight = 50
//2^arraySize or 2^n
knapSackRECURSIVE(values: values, weights: weights, maxWeight: maxWeight)
//O(arraySize*maxWeight) or O(nW)
knapSack(values: values, weights: weights, maxWeight: maxWeight)