object Main extends App {

  val possible = for {
    line <- io.Source.stdin.getLines
    nums = line.trim split raw"\s+" map (_.toInt)
    sorted = nums.sorted
    if sorted(0) + sorted(1) > sorted(2)
  } yield nums

  println(possible.length)

}
