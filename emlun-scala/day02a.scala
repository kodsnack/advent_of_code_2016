/**
  * Simple solution based on modeling the walk around the button pad as a
  * finite state machine.
  */
object Main extends App {

  val initialButton = '5'
  val moves = Map(
    '1' -> Map('U' -> '1', 'R' -> '2', 'D' -> '4', 'L' -> '1'),
    '2' -> Map('U' -> '2', 'R' -> '3', 'D' -> '5', 'L' -> '1'),
    '3' -> Map('U' -> '3', 'R' -> '3', 'D' -> '6', 'L' -> '2'),
    '4' -> Map('U' -> '1', 'R' -> '5', 'D' -> '7', 'L' -> '4'),
    '5' -> Map('U' -> '2', 'R' -> '6', 'D' -> '8', 'L' -> '4'),
    '6' -> Map('U' -> '3', 'R' -> '6', 'D' -> '9', 'L' -> '5'),
    '7' -> Map('U' -> '4', 'R' -> '8', 'D' -> '7', 'L' -> '7'),
    '8' -> Map('U' -> '5', 'R' -> '9', 'D' -> '8', 'L' -> '7'),
    '9' -> Map('U' -> '6', 'R' -> '9', 'D' -> '9', 'L' -> '8')
  )

  val presses = io.Source.stdin.getLines
    .scanLeft(initialButton) { (startButton, line) =>
      line.foldLeft(startButton) { (currentButton, move) => moves(currentButton)(move) }
    }
    .drop(1) // scanLeft outputs the initial '5' as the first element

  println(presses mkString "")

}
