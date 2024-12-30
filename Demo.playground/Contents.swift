import UIKit

var strArray = ["a","f","b","r","t","y"]
var intArray = [1,3,5,3,7,5,9]

var intmin = intArray[0]
var sortValue: [Int] = []

for i in intArray {
    if i <= intmin {
        intmin += i
        sortValue += intArray
    }
    print(sortValue)
}

