object Main extends App {

  val width = 50
  val height = 6

  val initialState: List[List[Boolean]] = List.fill(height)(List.fill(width)(false))

  def showState(state: List[List[Boolean]]): String =
    state map { row => row map { pixel => if (pixel) "#" else "." } mkString "" } mkString "\n"

  def rotate[T](list: List[List[T]], index: Int, steps: Int = 1): List[List[T]] =
    list.zipWithIndex.map {
      case (row, `index`) => {
        val (prefix, suffix) = row splitAt (row.length - steps)
        suffix ++ prefix
      }
      case (row, _) => row
    }

  val instructions = for {
    line <- io.Source.stdin.getLines
    instruction = line.trim
    words = (instruction split raw"\s+").toList
  } yield words

  val finalState = instructions.foldLeft(initialState) { (state, instruction) =>
    val nextState = instruction match {
      case List("rect", size) => {
        val (w, h) = size split "x" match {
          case Array(ws, hs) => (ws.toInt, hs.toInt)
        }

        state.zipWithIndex map { case (row, r) =>
          row.zipWithIndex map { case (pixel, c) =>
            pixel || (r + 1 <= h && c + 1 <= w)
          }
        }
      }

      case List("rotate", "row", a, "by", b) =>
        rotate(state, a.drop(2).toInt, b.toInt)

      case List("rotate", "column", a, "by", b) =>
        rotate(state.transpose, a.drop(2).toInt, b.toInt).transpose

      case _ => ???
    }

    println(instruction mkString " ")
    println(showState(nextState) + "\n")

    nextState
  }

  println("Pixels lit: " + (showState(finalState) count (_ == '#')))

}
