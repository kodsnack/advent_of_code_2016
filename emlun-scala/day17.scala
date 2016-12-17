import java.security.MessageDigest
import scala.collection.immutable.Queue

object Main extends App {

  val MD5 = MessageDigest.getInstance("MD5")
  def md5(s: String): String =
    MD5.digest(s.getBytes) take 2 map ("%02x" format _) mkString ""

  def step(state: State, move: Char): State =
    state match {
      case State(moves, (x, y)) =>
        val nextPos = move match {
          case 'U' => (x, y - 1)
          case 'D' => (x, y + 1)
          case 'L' => (x - 1, y)
          case 'R' => (x + 1, y)
        }
        State(state.moves + move, nextPos)
    }

  case class State(moves: String, pos: (Int, Int))

  def openedDoors(state: State, passcode: String): List[Char] =
    (md5(passcode + state.moves)
      take 4
      zip "UDLR"
      filter { case (hash, _) => "bcdef" contains hash }
    ).unzip._2.toList

  def solve(
      passcode: String,
      start: (Int, Int),
      xmax: Int,
      ymax: Int,
      target: (Int, Int)
  ): Set[State] = {
    def search(
        states: Queue[State],
        endStates: Set[State]
    ): Set[State] = {
      states.dequeueOption match {
        case None => endStates
        case Some((state, states)) => {
          println(s"search ${state.moves.length} ${states.length} ${endStates.size}")

          if (state.pos == target)
             search(states, endStates + state)
          else {
            val nextStates = for {
              move <- openedDoors(state, passcode)
              nextState = step(state, move)
              (x, y) = nextState.pos
              if (x >= 0 && x <= xmax && y >= 0 && y <= ymax)
            } yield nextState

            search(states enqueue nextStates, endStates)
          }
        }
      }
    }

    search(Queue(State("", start)), Set.empty)
  }

  val passcode = (io.Source.stdin mkString "").trim

  val start = (0, 0)
  val (xmax, ymax) = (3, 3)
  val target = (xmax, ymax)
  val endStates = solve(passcode, start, xmax, ymax, target)
  val solutionA = endStates minBy (_.moves.length)
  val solutionB = endStates maxBy (_.moves.length)

  println(s"A: ${solutionA}")
  println(s"B: ${solutionB.moves.length} ${solutionB}")

}
