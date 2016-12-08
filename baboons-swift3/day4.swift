
let input = CommandLine.arguments[1].components(separatedBy: "\n")

extension String {
    func mostCommon() -> String {
        var common = [String:Int]()
        for c in self.characters {
            if(common[String(c)] == nil) {
                common[String(c)] = 1
            } else {
                common[String(c)]! += 1
            }
        }

        return String(common.sorted(by: {$0.1 > $1.1}).sorted(by: {$0.0 < $1.0 && $0.1 == $1.1}).flatMap { String.CharacterView($0.0) }).substring(to: 5)
    }

    func rotate(_ num: Int) -> String {

        var key = [Character: Character]()
        let uppercase = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ".characters)
        let lowercase = Array("abcdefghijklmnopqrstuvwxyz".characters)

        for i in 0 ..< 26 {
            key[uppercase[i]] = uppercase[(i + num) % 26]
            key[lowercase[i]] = lowercase[(i + num) % 26]
        }

        return String(self.characters.map { key[$0] ?? $0 })
    }
}

var sectors = 0
var northpole = 0

for line in input {

    let matches = line.matchingStrings(regex: "([a-z\\-]+)\\-(\\d+)\\[([a-z]+)\\]")[0]
    let encrypted = matches[1].replacingOccurrences(of: "-", with: "")
    let sectorId = Int(matches[2])!
    let checksum =

    if(encrypted.mostCommon() == checksum) {
        sectors += sectorId
    }

    if encrypted.rotate(sectorId).range(of: "north") != nil {
        northpole = sectorId
    }

}

print("Part 1: \(sectors)")
print("Part 2: \(northpole)")