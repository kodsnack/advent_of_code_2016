
let input = CommandLine.arguments[1].components(separatedBy: "\n")

func validTriangle(_ triplet: [Int]) -> Bool {
    let triangle = triplet.sorted()
    return triangle[0] + triangle[1] > triangle[2]
}

var valid1 = 0
var valid2 = 0

for row in input {
    valid1 += validTriangle([
        Int(row.substring(with: 0..<5).trim())!,
        Int(row.substring(with: 5..<10).trim())!,
        Int(row.substring(with: 10..<15).trim())!
    ]) ? 1 : 0
}

for i in (0..<input.count) where i % 3 == 0 {
    print(input[i].substring(with: 0..<5))
    print(input[i+1].substring(with: 0..<5))
    print(input[i+2].substring(with: 0..<5))


    //print(input[i+1].substring(with: 2..<3))
    //print(input[i+2].substring(with: 2..<3))
}

print(valid1)