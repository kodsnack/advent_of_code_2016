fun advent2a() {
    val input = File("advent2.txt").readLines()
    val values = mapOf('L' to -1, 'R' to 1, 'U' to -3, 'D' to 3)
    var pos = 5

    for (line in input) {
        for (move in line) {
            if (move == 'L' && pos in listOf(1, 4, 7)) continue
            if (move == 'R' && pos in listOf(3, 6, 9)) continue
            if (move == 'U' && pos in listOf(1, 2, 3)) continue
            if (move == 'D' && pos in listOf(7, 8, 9)) continue
            pos += values[move]!!
        }
        print(pos)
    }
    println()
}

fun advent2b() {
    val input = File("advent2.txt").readLines()
    val values = mapOf('L' to -1, 'R' to 1, 'U' to -4, 'D' to 4)
    val letters = mapOf(10 to 'A', 11 to 'B', 12 to 'C', 13 to 'D')
    var pos = 5

    for (line in input) {
        for (move in line) {
            if (move == 'L' && pos in listOf(1, 2, 5, 10, 13)) continue
            if (move == 'R' && pos in listOf(1, 4, 9, 12, 13)) continue
            if (move == 'U' && pos in listOf(5, 2, 1, 4, 9)) continue
            if (move == 'D' && pos in listOf(5, 10, 13, 12, 9)) continue

            if      (move == 'U' && pos in listOf(3, 13)) pos += values[move]!! / 2
            else if (move == 'D' && pos in listOf(1, 11)) pos += values[move]!! / 2
            else    pos += values[move]!!
        }
        print(if (pos > 9) letters[pos]!! else pos)
    }
    println()
}