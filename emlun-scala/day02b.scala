/**
  * Simple solution based on modeling the walk around the button pad as a
  * finite state machine.
  */
object Main extends App {

  val initialButton = '5'
  val moves = Map(
    '1' -> Map('U' -> '1', 'R' -> '1', 'D' -> '3', 'L' -> '1'),
    '2' -> Map('U' -> '2', 'R' -> '3', 'D' -> '6', 'L' -> '2'),
    '3' -> Map('U' -> '1', 'R' -> '4', 'D' -> '7', 'L' -> '2'),
    '4' -> Map('U' -> '4', 'R' -> '4', 'D' -> '8', 'L' -> '3'),
    '5' -> Map('U' -> '5', 'R' -> '6', 'D' -> '5', 'L' -> '5'),
    '6' -> Map('U' -> '2', 'R' -> '7', 'D' -> 'A', 'L' -> '5'),
    '7' -> Map('U' -> '3', 'R' -> '8', 'D' -> 'B', 'L' -> '6'),
    '8' -> Map('U' -> '4', 'R' -> '9', 'D' -> 'C', 'L' -> '7'),
    '9' -> Map('U' -> '9', 'R' -> '9', 'D' -> '9', 'L' -> '8'),
    'A' -> Map('U' -> '6', 'R' -> 'B', 'D' -> 'A', 'L' -> 'A'),
    'B' -> Map('U' -> '7', 'R' -> 'C', 'D' -> 'D', 'L' -> 'A'),
    'C' -> Map('U' -> '8', 'R' -> 'C', 'D' -> 'C', 'L' -> 'B'),
    'D' -> Map('U' -> 'B', 'R' -> 'D', 'D' -> 'D', 'L' -> 'D')
  )

  val presses = io.Source.stdin.getLines
    .scanLeft(initialButton) { (startButton, line) =>
      line.foldLeft(startButton) { (currentButton, move) => moves(currentButton)(move) }
    }
    .drop(1) // scanLeft outputs the initial '5' as the first element

  println(presses mkString "")

}
