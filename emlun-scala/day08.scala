object Main extends App {

  val width = 50
  val height = 6

  var state: List[List[Boolean]] = List.fill(height)(List.fill(width)(false))

  def printState(state: List[List[Boolean]]) {
    state foreach { row => println(row map { pixel => if (pixel) "#" else "." } mkString "") }
  }

  for {
    line <- io.Source.stdin.getLines
    instruction = line.trim
    words = (instruction split raw"\s+").toList
  } {
    words match {
      case List("rect", size) =>
        val (w, h) = size split "x" match {
          case Array(xs, ys) => (xs.toInt, ys.toInt)
        }
        println(s"rect $w $h")

        state = state.zipWithIndex map { case (row, r) =>
          row.zipWithIndex map { case (pixel, c) =>
            pixel || (r + 1 <= h && c + 1 <= w)
          }
        }

      case List("rotate", "row", rawA, "by", b) =>
        val a = rawA.tail.tail.toInt

        println(s"rotate row $a, $b")

        for (i <- 1 to b.toInt) {
          state = state.zipWithIndex map { case (row, y) =>
            if (y == a)
              row.last +: row.init
            else
              row
          }
        }

      case List("rotate", "column", rawA, "by", b) =>
        val a = rawA.tail.tail.toInt

        println(s"rotate column $a, $b")

        for (i <- 1 to b.toInt) {
          state = (
            state
              .transpose
              .zipWithIndex
              .map { case (col, x) =>
                if (x == a)
                  col.last +: col.init
                else
                  col
              }
              .transpose
          )
        }

      case _ =>
    }

    printState(state)
  }

  println("Pixels lit: " + (state map { row => (row map (pixel => if (pixel) 1 else 0)).sum }).sum)

}
