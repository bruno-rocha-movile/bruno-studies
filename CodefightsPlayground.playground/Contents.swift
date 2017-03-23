import Foundation

func checkPalindrome(inputString: String) -> Bool {
    for i in 0..<inputString.characters.count {
        if inputString[inputString.index(inputString.startIndex, offsetBy: i)] != inputString[inputString.index(inputString.startIndex, offsetBy: inputString.characters.count - 1 - i)] {
            return false
        }
    }
    return true
}


checkPalindrome(inputString: "aabb")
checkPalindrome(inputString: "aabaa")