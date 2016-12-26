object Main extends App {

  def solve(elves: List[Int], currentMove: Int = 0): Int = {
    println(elves)
    elves.length match {
      case 1 => elves.head
      case 2 => elves.head
      case l if l % 2 == 0 =>
        solve(elves.grouped(2).map(_.head).toList)
      case _ =>
        solve(elves.grouped(2).map(_.head).toList.tail)
    }
  }

  val numElves = (io.Source.stdin mkString "").trim.toInt

  println("A: " + solve((1 to numElves).toList))

}
