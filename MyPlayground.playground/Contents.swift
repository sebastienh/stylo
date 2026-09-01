import UIKit

var colors = "d8e3e9-8abad0-4082a0-3e7d99-3b7792-38718b-356b83-2f5f75-295367-234758"

let colorArray = colors.split(separator: "-")

var property = "--teal"

var result = ""

for (index, color) in colorArray.enumerated() {
    result += "\(property)-t\(index+1): #\(color);\n"
}

print(result)


// eac0ae-dd9a7e-d0744d-cc683e-c15e33-b1562f-a14e2b-914727-813f22-71371e
