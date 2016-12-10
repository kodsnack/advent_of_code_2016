object Main extends App {

  val repeatPattern = raw"^\((\d+)x(\d+)\)".r.unanchored
  val noRepeatPattern = raw"^([^(]+)".r.unanchored

  var input = io.Source.stdin.getLines map (_.trim) mkString ""

  var output = ""

  while (input.length > 0) {
    input match {
      case repeatPattern(numChars, times) => {
        input = input.substring((repeatPattern findFirstIn input).get.length)

        val repeatChars = input.substring(0, numChars.toInt)
        input = input.substring(repeatChars.length)
        (1 to (times.toInt)).foreach { j =>
          output += repeatChars
        }
      }

      case _ => {
        output += input.charAt(0)
        input = input.substring(1)
      }
    }

    println("in " + input)
    println("out " + output)
  }

  println(output.length)

}
