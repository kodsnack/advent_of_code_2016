
let input = CommandLine.arguments[1].components(separatedBy: ", ")

extension Array where Element: Integer {
    mutating func rotate(_ direction: String) -> Array {

        let x = self[0] as! Int
        let y = self[1] as! Int

        let change = (direction == "R" && x != 0) || (direction == "L" && y != 0)

        return [(change ? y * -1 : y * 1) as! Element, (change ? x * -1 : x * 1) as! Element]
    }

}

var x = 0
var y = 0
var direction = [0,1]
var visited = [(Int,Int)]()
var found = false

for step in input {
    var distance: Int! = Int(step.substring(from: 1))
    direction = direction.rotate(step.substring(to: 1))

    for i in (0..<distance) {
        x += 1 * direction[0]
        y += 1 * direction[1]

        if !found && visited.contains(where: {$0 == (x,y)}) {
            print("Part 2: " + String(abs(x) + abs(y)))
            found = true
        } else {
            visited.append((x,y))
        }

    }
}

print("Part 1: " + String(abs(x) + abs(y)))
