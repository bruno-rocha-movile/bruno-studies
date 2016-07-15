//: [Previous](@previous)

public struct HashTable<Key: Hashable, Value> {
    private typealias Element = (key: Key, value: Value)
    private typealias Bucket = [Element]
    private var buckets: [Bucket]
    
    init(size: Int) {
        assert(size > 0)
        buckets = .init(count: size, repeatedValue: [])
    }
}

extension HashTable {
    private func indexForKey(key: Key) -> Int {
        return abs(key.hashValue) % buckets.count
    }
    
    public subscript(key: Key) -> Value? {
        get {
            return valueOf(key)
        }
        set(newValue) {
            guard let value = newValue else {
                remove(key)
                return
            }
            update(value, forKey: key)
        }
    }
    
    private func valueOf(key: Key) -> Value? {
        let index = indexForKey(key)
        for element in buckets[index] {
            if element.key == key {
                return element.value
            }
        }
        return nil
    }
    
    private mutating func update(value: Value, forKey key: Key) {
        let index = indexForKey(key)
        for (i, element) in buckets[index].enumerate() {
            if element.key == key {
                buckets[index][i].value = value
            }
        }
        buckets[index].append((key: key, value: value))
    }
    
    public mutating func remove(key: Key) {
        let index = indexForKey(key)
        for (i, element) in buckets[index].enumerate() {
            if element.key == key {
                buckets[index].removeAtIndex(i)
            }
        }
    }
}

var table = HashTable<String, Int>(size: 5)

table["John"] = 1994
table["babie"] = 1976
table["babie"] = 2222
table["babie"]

//: [Next](@next)
