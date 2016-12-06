import math.abs

object Main extends App {

  case class State(
    loc: (Int, Int) = (0, 0),
    dir: (Int, Int) = (1, 0),
    preVisited: Set[(Int, Int)] = Set.empty
  )

  val steps = for {
    line <- io.Source.stdin.getLines
    step <- line.trim.split(raw"\s*,\s*")
    turn = step(0)
    length = step.tail.toInt
    substep <- turn +: List.fill(length - 1)('F')
  } yield substep

  val states = steps.scanLeft(State()) { (state, step) =>
    val dir = step match {
      case 'F' => state.dir
      case 'L' => (state.dir._2, -state.dir._1)
      case 'R' => (-state.dir._2, state.dir._1)
    }

    State(
      loc = (state.loc._1 + dir._1, state.loc._2 + dir._2),
      dir = dir,
      preVisited = state.preVisited + state.loc
    )
  }

  val bunnyHQ = states
    .find { state => state.preVisited contains state.loc }
    .get
    .loc

  println(s"Location of Bunny HQ: ${bunnyHQ}")
  println(s"Distance: ${abs(bunnyHQ._1) + abs(bunnyHQ._2)}")
}
