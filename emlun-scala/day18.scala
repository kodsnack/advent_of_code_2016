object Main extends App {

  def nextRow(prevRow: String): String = (
    ('.' + prevRow + '.')
      sliding 3
      map {
        case "^^." | ".^^" | "^.." | "..^" => '^'
        case _ => '.'
      }
      mkString ""
  )

  def solve(numRows: Int, row: String, numSafe: Int = 0): Int = {
    val nextNumSafe = numSafe + (row count (_ == '.'))
    if (numRows == 1) nextNumSafe
    else solve(numRows - 1, nextRow(row), nextNumSafe)
  }

  val firstRow = (io.Source.stdin mkString "").trim

  println("A: " + solve(40, firstRow))
  println("B: " + solve(400000, firstRow))

}
