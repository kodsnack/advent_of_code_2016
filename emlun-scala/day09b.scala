object Main extends App {

  val repeatPattern = raw"^\((\d+)x(\d+)\)".r.unanchored

  var input = io.Source.stdin.getLines map (_.trim) mkString ""
  var outputLength: Long = 0
  var multipliers: List[(Int, Int)] = Nil // (length, multiplier)

  println("in length " + input.length)
  println("out length " + outputLength)
  println()

  while (input.length > 0) {
    input match {
      case repeatPattern(numChars, times) => {
        val matchLength = (repeatPattern findFirstIn input).get.length
        input = input drop matchLength

        multipliers = multipliers map { case (length, multiplier) => (length - matchLength, multiplier) }
        multipliers = multipliers filter { case (length, multiplier) => length > 0 }
        multipliers = multipliers :+ (numChars.toInt, times.toInt)
      }

      case _ => {
        val matchLength = 1
        outputLength += multipliers.foldLeft(1) { (result, mult) => result * mult._2 }
        multipliers = multipliers map { case (length, multiplier) => (length - matchLength, multiplier) }
        multipliers = multipliers filter { case (length, multiplier) => length > 0 }
        input = input.tail
      }
    }

    // println("in " + input)
    println("in length " + input.length)
    println("out length " + outputLength)
    println("multipliers " + multipliers)
    println()

    // println((input.length, outputLength))
  }

  println(outputLength)

}
