object Main extends App {

  val repeatPattern = raw"\((\d+)x(\d+)\)".r

  case class Multiplier(length: Int, magnitude: Int) {
    def decay: Option[Multiplier] =
      if (length > 1) Some(Multiplier(length - 1, magnitude))
      else None
  }

  def stepMultipliers(multipliers: List[Multiplier], steps: Int): (Int, List[Multiplier]) =
    if (steps == 0)
      (0, multipliers)
    else {
      val stepSize = multipliers.map(_.magnitude).product
      val decayedMultipliers = multipliers flatMap (_.decay)
      stepMultipliers(decayedMultipliers, steps - 1) match {
        case (stepsTaken, newMultipliers) => (stepSize + stepsTaken, newMultipliers)
      }
    }

  def solve(
      input: CharSequence,
      multipliers: List[Multiplier] = Nil,
      outputLength: Long = 0
  ): Long = {

    println()
    println("in length " + input.length)
    println("out length " + outputLength)
    println("multipliers " + multipliers)

    repeatPattern findFirstMatchIn input match {
      case Some(repeat) => {
        val numChars = (repeat group 1).toInt
        val times = (repeat group 2).toInt

        val (stepsTaken, multipliersAtRepeat) = stepMultipliers(multipliers, repeat.before.length)

        println("Before " + repeat.before)
        println("Repeat " + repeat)
        println("Advance " + stepsTaken)

        val (_, multipliersAfterRepeat) = stepMultipliers(multipliersAtRepeat, repeat.matched.length)

        val nextMultipliers = Multiplier(numChars, times) +: multipliersAfterRepeat

        solve(repeat.after, nextMultipliers, outputLength + stepsTaken)
      }
      case None => {
        val (stepSize, _) = stepMultipliers(multipliers, input.length)
        println("Finish")
        println("Advance " + stepSize)
        outputLength + stepSize
      }
    }
  }

  val input = io.Source.stdin.mkString.trim
  println(solve(input))

}
