import scala.collection.immutable.SortedSet

object Main extends App {

  case class Point(x: Int, y: Int) {
    def neighbors: Set[Point] =
      Set(Point(x - 1, y), Point(x + 1, y), Point(x, y - 1), Point(x, y + 1))
  }
  case class Node(pos: Point, used: Int, avail: Int) {
    val capacity: Int = used + avail
  }
  case class Move(from: Node, to: Node)

  case class Grid(nodes: List[List[Node]]) {
    def apply(p: Point): Option[Node] = nodes lift p.y flatMap { row => row lift p.x }

    private def isViablePair(a: Node, b: Node): Boolean = (
      a.used != 0
      && a.pos != b.pos
      && a.used <= b.avail
    )

    lazy val viablePairs: Set[(Node, Node)] = {
      val allNodes = nodes.flatten.toSet
      for {
        a <- allNodes
        b <- allNodes - a
        if isViablePair(a, b)
      } yield (a, b)
    }

    def showRoutes(routes: Set[List[Point]], wantedDataPosition: Point, destination: Option[Point]): String = {
      val routePoints = routes.flatten

      nodes.zipWithIndex map { case (row, y) =>
        row.zipWithIndex map { case (node, x) =>
          val cell =
            if (Point(x, y) == wantedDataPosition) 'G'
            else if (routePoints contains Point(x, y)) '+'
            else if (!(viablePairs exists { case (from, to) => from == node || to == node })) "#"
            else if (apply(Point(x, y)) map { node => node.used == 0 } getOrElse false) '_'
            else '.'

          if (Some(Point(x, y)) == destination) s"($cell)"
          else s" $cell "
        } mkString ""
      } mkString "\n"
    }

    def maxUsed(route: List[Point]): Int = route.flatMap(n => apply(n)).map(_.used).max
  }

  def solve(grid: Grid, start: Point, destination: Point): List[Point] = {

    def findSetup(routes: Set[List[Point]]): Set[List[Point]] = {
      println(s"Routes: ${routes.size}")
      println(grid.showRoutes(routes, destination, Some(start)))

      val finishedRoutes = routes filter { route =>
        route lift 1 flatMap { p => grid(p) } map { grid(route.head).get.avail >= _.used } getOrElse false
      }

      if (!finishedRoutes.isEmpty) {
        println(s"Finished: ${finishedRoutes.size}")
        finishedRoutes
      } else {
        val visited: Set[Point] = routes.flatten
        val nextRoutes: Set[List[Point]] = (
          routes
            flatMap { route =>
              val minCapacity = route lift 1 flatMap { p => grid(p) } map { _.used } getOrElse 0
              val nextHeads: Set[Point] =
                (
                  route.head.neighbors filter { point =>
                    grid(point) match {
                      case None => false
                      case Some(node: Node) => node.capacity >= minCapacity
                    }
                  }
                ) -- visited
              nextHeads map { nextHead => nextHead +: route }
            }
            groupBy { route => route.head }
            mapValues { routes =>
              routes minBy { route => grid.maxUsed(route) }
            }
        ).values.toSet

        println(s"${nextRoutes.size} next routes")
        // println(nextRoutes mkString "\n")
        findSetup(nextRoutes)
      }
    }

    findSetup(Set(List(start))) minBy { _.length }
  }

  val nodePattern = raw"/dev/grid/node-x(\d+)-y(\d+)\s+\S+\s+(\S+)T\s+(\S+)T.*".r

  val nodeGroups: Map[Int, Set[Node]] = (for {
    line <- io.Source.stdin.getLines
    node <- line.trim match {
      case nodePattern(x, y, used, avail) => Some(Node(Point(x.toInt, y.toInt), used.toInt, avail.toInt))
      case _ => None
    }
  } yield node).toSet groupBy { _.pos.y }

  val nodeRows: List[List[Node]] = nodeGroups.keys.toList.sorted.map(y => nodeGroups(y).toList.sortBy(_.pos.x))
  val wantedDataPosition = Point(
    nodeRows.head.map(_.pos.x).max,
    0
  )
  val destination = Point(0, 0)

  val grid = Grid(nodeRows)

  val solution = solve(grid, wantedDataPosition, destination)

  println(grid.showRoutes(Set(solution), wantedDataPosition, Some(destination)))

  val winningRouteNodes = solution map { p => grid(p).get }

  println("Viable pairs: " + grid.viablePairs.size)
  println(s"Setup in ${solution.length - 1} steps!")
  println(s"Victory in ${solution.length + 196} steps!")

}
