import scala.collection.immutable.NumericRange

object Main extends App {

  type LongRange = NumericRange.Inclusive[Long]
  def merge(ranges: List[LongRange]): List[LongRange] = {
    val result = ranges.tail.foldLeft(ranges take 1) { (bigRanges, nextRange) =>
      val lastRange = bigRanges.last
      if (lastRange.max + 1 < nextRange.min)
        bigRanges :+ nextRange
      else
        bigRanges.init :+ (Math.min(lastRange.min, nextRange.min) to Math.max(lastRange.max, nextRange.max))
    }
    if (result == ranges) result
    else merge(result)
  }

  val notRanges = (for {
    line <- io.Source.stdin.getLines
    (low: Long, high: Long) = line.trim.split("-") match {
      case Array(l, h) => (l.toLong, h.toLong)
    }
  } yield low to high).toList sortBy { _.max }

  val mergedRanges = merge(notRanges)

  val numForbidden: Long = mergedRanges.map(_.size.toLong).sum

  println("A: " + (mergedRanges.head.max + 1))
  println("B: " + (4294967296L - numForbidden))

}
