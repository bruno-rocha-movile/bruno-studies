//: Playground - noun: a place where people can play

import UIKit

extension String {
    
    func dataFromHexadecimalString() -> NSData? {
        let trimmedString = self.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<> ")).stringByReplacingOccurrencesOfString(" ", withString: "")
        
        // make sure the cleaned up string consists solely of hex digits, and that we have even number of them
        
        let regex = try! NSRegularExpression(pattern: "^[0-9a-f]*$", options: .CaseInsensitive)
        
        let found = regex.firstMatchInString(trimmedString, options: [], range: NSMakeRange(0, trimmedString.characters.count))
        if found == nil || found?.range.location == NSNotFound || trimmedString.characters.count % 2 != 0 {
            return nil
        }
        
        // everything ok, so now let's build NSData
        
        let data = NSMutableData(capacity: trimmedString.characters.count / 2)
        
        for var index = trimmedString.startIndex; index < trimmedString.endIndex; index = index.successor().successor() {
            let byteString = trimmedString.substringWithRange(Range<String.Index>(start: index, end: index.successor().successor()))
            let num = UInt8(byteString.withCString { strtoul($0, nil, 16) })
            data?.appendBytes([num] as [UInt8], length: 1)
        }
        
        return data
    }
}

extension String {
    var binaryData: NSData {
        return self.dataFromHexadecimalString() ?? NSData()
    }
    var base64: String {
        let binaryData = self.binaryData
        return binaryData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0)) ?? ""
    }
}

extension UnsafeMutableBufferPointer {
    var asHex: String {
        let bytes = self
        let hexString = NSMutableString()
        for byte in bytes {
            hexString.appendFormat("%02x", UInt(byte as! UInt8))
        }
        return hexString as String
    }
}

func xorEqualStrings(hex1: String, hex2: String) -> UnsafeMutableBufferPointer<UInt8> {
    let ptr = UnsafeMutablePointer<UInt8>(hex1.binaryData.bytes)
    let hexbytes = UnsafeMutableBufferPointer<UInt8>(start: ptr, count: hex1.binaryData.length)
    let ptr2 = UnsafePointer<UInt8>(hex2.binaryData.bytes)
    let hex2bytes = UnsafeBufferPointer<UInt8>(start:ptr2, count:hex2.binaryData.length)
    for i in 0..<hex1.binaryData.length {
        hexbytes[i] ^= hex2bytes[i]
    }
    return hexbytes
}

let hexbytes = xorEqualStrings("1c0111001f010100061a024b53535009181c", hex2: "686974207468652062756c6c277320657965")

//print(String(bytes: hexbytes, encoding: NSUTF8StringEncoding))
print(hexbytes.asHex)