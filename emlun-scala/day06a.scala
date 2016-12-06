object Main extends App {

  val message = for {
    repetitions <- io.Source.stdin.getLines.toList.transpose
    mostCommon = (
      repetitions
        .sortBy { c => repetitions count (_ == c) }
        .last
    )
  } yield mostCommon

  println(message mkString "")

}
