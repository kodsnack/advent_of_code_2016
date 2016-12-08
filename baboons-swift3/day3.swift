
let input = CommandLine.arguments[1].components(separatedBy: "\n")

func validTriangle(_ triplet: [Int]) -> Bool {
    let triangle = triplet.sorted()
    return triangle[0] + triangle[1] > triangle[2]
}

var valid = (0,0)

for row in input {
    valid.0 += validTriangle([
            Int(row.substring(with: 0..<5).trim())!,
            Int(row.substring(with: 5..<10).trim())!,
            Int(row.substring(with: 10..<15).trim())!
    ]) ? 1 : 0
}

for i in (0..<input.count) where i % 3 == 0 {
    for j in(0..<3) {
        valid.1 += validTriangle([
                Int(input[i].substring(with: j*5..<j*5+5).trim())!,
                Int(input[i+1].substring(with: j*5..<j*5+5).trim())!,
                Int(input[i+2].substring(with: j*5..<j*5+5).trim())!
        ]) ? 1: 0
    }
}


print("Part 1: " + String(valid.0))
print("Part 2: " + String(valid.1))