object Main extends App {

  val discPattern = raw"Disc #\d+ has (\d+) positions; at time=0, it is at position (\d+).".r

  def solve(discs: List[(Int, Int)]): Option[Int] = {
    val wantPositions: List[Int] = discs.zipWithIndex map {
      case ((positions, _), index) => (positions * (index + 1) - (index + 1)) % positions
    }
    val maxPeriod = discs map (_._1) reduce { (product, factor) => product * factor }

    0 to maxPeriod find { t =>
      val discPositions = discs map {
        case (positions, startPosition) => (startPosition + t) % positions
      }

      discPositions == wantPositions
    }
  }

  val discs: List[(Int, Int)] = io.Source.stdin.getLines.toList map {
    case discPattern(positions, startPosition) => (positions.toInt, startPosition.toInt)
  }

  println("A: " + solve(discs))
  println("B: " + solve(discs :+ (11, 0)))

}
