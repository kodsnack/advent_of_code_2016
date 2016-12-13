import scala.collection.immutable.Queue

object Main extends App {

  def solve(
      seed: Int,
      start: (Int, Int),
      target: (Int, Int)
  ): Option[List[(Int, Int)]] = {
    def isWall(point: (Int, Int)): Boolean =
      point match {
        case (x, y) =>
          x < 0 || y < 0 || (
            ((x*x + 3*x + 2*x*y + y + y*y + seed).toBinaryString count (_ == '1')) % 2 == 1
          )
      }

    def search(
        prevPositions: Set[(Int, Int)] = Set.empty,
        nextPaths: Queue[List[(Int, Int)]] = Queue.empty
    ): Option[List[(Int, Int)]] =
      nextPaths.dequeueOption match {
        case None => None // Can't do flatMap because Scala won't optimize that as tail-call recursion
        case Some((path, nextNextPaths)) => {
          if (path.last == target) {
            Some(path)
          } else if (prevPositions contains path.last) {
            search(prevPositions, nextNextPaths)
          } else {
            val possibleNextPaths = for {
              dxdy <- List((0, 1), (1, 0), (0, -1), (-1, 0))
              nextPos = (path.last._1 + dxdy._1, path.last._2 + dxdy._2)
              if !isWall(nextPos)
            } yield path :+ nextPos

            search(prevPositions + path.last, nextNextPaths enqueue possibleNextPaths)
          }
        }
      }

    search(nextPaths = Queue(List(start)))
  }

  val seed: Int = (io.Source.stdin.getLines map (_.trim) mkString "" ).toInt
  solve(seed, (1, 1), (31, 39)) match {
    case Some(path) => {
      println(s"Winning path: ${path}")
      println((path.length - 1) + " steps")
    }
    case None => {
      println("No winning path found. :(")
    }
  }

}
