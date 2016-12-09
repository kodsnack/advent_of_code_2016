let input = CommandLine.arguments[1].components(separatedBy: "\n")

func sorted(_ l: [[String:Int]], asc: Bool ) -> String {
    var string = ""
    for row in l {
        string += asc ? row.sorted(by: {$0.1 < $1.1})[0].0 : row.sorted(by: {$0.1 > $1.1})[0].0
    }

    return string
}

var letters = [[String:Int]]()

for string in input {
    for i in 0..<string.characters.count {
        let char = string.substring(with: i..<i+1)

        if(!letters.indices.contains(i)) {
            letters.append([:])
        }

        if(letters[i][char] == nil) {
            letters[i][char] = 0
        }

        letters[i][char]! += 1
    }
}

print("Part 1: \(sorted(letters, asc: false))")
print("Part 1: \(sorted(letters, asc: true))")