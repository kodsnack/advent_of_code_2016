object Main extends App {

  val possible = for {
    lineGroup <- io.Source.stdin.getLines grouped 3
    numLines = lineGroup map { line => line.trim split raw"\s+" map (_.toInt) }
    triangle <- numLines.transpose
    sorted = triangle.sorted
    if sorted(0) + sorted(1) > sorted(2)
  } yield triangle

  println(possible.length)

}
