fun advent3a() {
    val input = File("advent3.txt")
            .readLines()
            .map {
                it.trim()
                  .split(Regex("\\s+"))
                  .map(String::toInt)
                  .sorted() }

    println(input.filter { it[0]+it[1] > it[2] }.count())
}

fun advent3b() {
    val input2 = File("advent3.txt")
            .readLines()
            .flatMap {
                it.trim()
                  .split(Regex("\\s+"))
                  .map(String::toInt) }

    val a = input2.filterIndexed { i, x -> i % 3 == 0 }
    val b = input2.filterIndexed { i, x -> i % 3 == 1 }
    val c = input2.filterIndexed { i, x -> i % 3 == 2 }
    val all = a + b + c

    val count = (0 until all.size step 3)
            .map { listOf(all[it], all[it+1], all[it+2]).sorted() }
            .filter { it[0]+it[1] > it[2] }
            .count()

    println(count)
}