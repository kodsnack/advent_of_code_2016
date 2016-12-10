
let input = CommandLine.arguments[1].components(separatedBy: "\n")

var movement: [String:(Int, Int)] = [
    "U" : (0,-1),
    "D" : (0,1),
    "L" : (-1,0),
    "R" : (1,0)
]

let keypad1: [[String]] = [
    ["1","2","3"],
    ["4","5","6"],
    ["7","8","9"]
]

let keypad2: [[String]]  = [
      ["","","1","",""],
     ["","2","3","4",""],
    ["5","6","7","8","9"],
     ["","A","B","C",""],
      ["","","D","",""],
]

func getPassword(_ keypad: Array<Array<String>>) -> String {
    var password = ""
    var position = (1,1)

    for line in input {
        for direction in line.characters {
            let x = movement[String(direction)]!.0
            let y = movement[String(direction)]!.1

            if(keypad.indices.contains(position.1 + y) && !keypad[position.1 + y][position.0].isEmpty) {
                position.1 += y
            }

            if(keypad[position.1].indices.contains(position.0 + x) && !keypad[position.1][position.0 + x].isEmpty) {
                position.0 += x
            }
        }

        password = password + keypad[position.1][position.0]
    }

    return password
}



print("Part 1: " + getPassword(keypad1))
print("Part 2: " + getPassword(keypad2))