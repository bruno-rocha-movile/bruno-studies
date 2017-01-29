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
                if (n==0 || w==0) {
                    table[n][w] = 0;
                } else if (weights[n-1] <= w) {
                    table[n][w] = max(values[n-1] + table[n-1][w-weights[n-1]],  table[n-1][w]);
                } else {
                    table[n][w] = table[n-1][w];
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