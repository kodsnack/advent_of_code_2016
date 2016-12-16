data class Instruction(val dir: Char, val steps: Int)
data class Position(val x: Int, val y: Int)
val cardinals = listOf('S', 'W', 'N', 'E')

fun advent1a() {
    val input = File("advent1.txt").readText().split(", ")
    val instructions = input.map { Instruction(it.first(), it.drop(1).toInt())  }

    var x = 0
    var y = 0
    var facing = 2 // index 2 in cardinals -> N

    for ((dir, steps) in instructions) {
        if (dir == 'R') facing = (facing + 5) % 4
        if (dir == 'L') facing = (facing + 3) % 4
        if (cardinals[facing] in listOf('N', 'S')) y += steps * (facing - 1)
        if (cardinals[facing] in listOf('E', 'W')) x += steps * (facing - 2)
    }

    println(abs(x) + abs(y))
}

fun advent1b() {
    val input = File("advent1.txt").readText().split(", ")
    val instructions = input.map { Instruction(it.first(), it.drop(1).toInt())  }

    var x = 0
    var y = 0
    var facing = 2 // index 2 in cardinals -> N
    val visited = mutableSetOf(Position(0,0))

    for ((dir, steps) in instructions) {
        if (dir == 'R') facing = (facing + 5) % 4
        if (dir == 'L') facing = (facing + 3) % 4

        repeat(steps) {
            x += if (cardinals[facing] in listOf('W', 'E')) facing-2 else 0
            y += if (cardinals[facing] in listOf('N', 'S')) facing-1 else 0
            if (!visited.add(Position(x, y))) {
                println(abs(x) + abs(y))
                return
            }
        }
    }
}