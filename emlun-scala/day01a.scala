import math.abs

object Main extends App {

  val steps = for {
    line <- io.Source.stdin.getLines
    step <- line.split(",")
  } yield step.trim

  case class State(
    loc: (Int, Int) = (0, 0),
    dir: (Int, Int) = (1, 0)
  )

  val finalState = steps.foldLeft(State()) { (state, move) =>
    val dir = move(0) match {
      case 'R' => (-state.dir._2, state.dir._1)
      case 'L' => (state.dir._2, -state.dir._1)
    }

    val length = move.tail.toInt

    State(
      (state.loc._1 + dir._1 * length, state.loc._2 + dir._2 * length),
      dir
    )
  }

  println(finalState)

  val bunnyHQ = finalState.loc

  println(s"Location of Bunny HQ: ${bunnyHQ}")
  println(s"Distance: ${abs(bunnyHQ._1) + abs(bunnyHQ._2)}")

}
