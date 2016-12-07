object Main extends App {

  val abaPattern = raw"(.)((?!\1).)\1".r
  def findAbas(segments: Iterable[String]): Set[(String, String)] =
    (
      for {
        segment <- segments
        subsegment <- segment.tails
        aba <- subsegment take 3 match {
          case abaPattern(a, b) => Some((a, b))
          case _ => None
        }
      } yield aba
    ).toSet

  val abas = for {
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
    outsideAbas = findAbas(outsideSegments)
    insideAbas = findAbas(insideSegments)
    if !(outsideAbas intersect (insideAbas map (_.swap))).isEmpty
  } yield (line, outsideAbas, insideAbas)

  println(abas.length)

}
