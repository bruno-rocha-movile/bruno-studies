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
                let previousItem = n-1
                guard n != 0 && w != 0 else {
                    continue
                }
                if (weights[thisItem] <= w) {
                    //If the item can be added, the value of this table's position will be the best of these cases: The value of the item, plus whatever the best case is of the remaining weight, or the best case if you don't add it (which is already calculated)
                    table[n][w] = max(values[thisItem] + table[previousItem][w-weights[thisItem]],  table[previousItem][w]);
                } else {
                    //If it can't be added, then the value will be the best case without adding the item
                    table[n][w] = table[previousItem][w];
                }
            }
        }
        //Which items were used?
        func reconstruct(_ i: Int, _ weight: Int) -> [Int] {
            if i == 0 {
                return []
            }
            if table[i][weight] > table[i-1][weight] {
                return [values[i-1]] + reconstruct(i-1, weight - weights[i-1])
            } else {
                return reconstruct(i-1, weight)
            }
        }
        print("knapsack value: \(table[arraySize][maxWeight])")
        print(reconstruct(values.count, maxWeight))
        //
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


//Coin Change

func coinChange(coins: [Int], amount: Int) -> Int {
    // int[amount+1][coins]
    var table = Array<Array<Int>>(repeating: Array<Int>(repeating: 0, count: coins.count), count: amount + 1)
    
    for i in 0..<coins.count {
        table[0][i] = 1
    }
    
    for i in 1...amount {
        for j in 0..<coins.count {
            
            //solutions that include s[j]
            let x = i - coins[j] >= 0 ? table[i - coins[j]][j] : 0
            //solutions that don't include s[j]
            let y = j >= 1 ? table[i][j-1] : 0
            
            table[i][j] = x + y
        }
    }
    return table[amount][coins.count - 1];
}
//1.1.1.1, 2.2, 2.1.1, 3.1

//(1) 1 1 1 1
//(1) 1 2 2 3




//(1) 1 2 3 4

let coins = [1,2,3]
let amount = 4
coinChange(coins: coins, amount: amount)
