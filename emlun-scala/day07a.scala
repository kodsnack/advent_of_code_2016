object Main extends App {

  val abbaPattern = raw".*(.)((?!\1).)\2\1.*"
  val abbas = for {
    line <- io.Source.stdin.getLines
    (outsideSegments, insideSegments, _) = (
      line.trim
        .foldLeft((List(""), List.empty[String], false)) { (result, nextChar) =>
          result match {
            case (out, in, isInside) =>
              nextChar match {
                case '[' => (out, in :+ "", true)
                case ']' => (out :+ "", in, false)
                case _ =>
                  if (isInside)
                    (out, in.init :+ (in.last + nextChar), isInside)
                  else
                    (out.init :+ (out.last + nextChar), in, isInside)
              }
          }
        }
      )
    if (outsideSegments find { _ matches abbaPattern }).isDefined
    if !(insideSegments find { _ matches abbaPattern }).isDefined
  } yield (line, outsideSegments, insideSegments)

  println(abbas.length)

}
