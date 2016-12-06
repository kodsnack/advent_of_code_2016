object Main extends App {

  val message = for {
    repetitions <- io.Source.stdin.getLines.toList.transpose
    leastCommon = (
      repetitions
        .sortBy { c => repetitions count (_ == c) }
        .head
    )
  } yield leastCommon

  println(message mkString "")

}
