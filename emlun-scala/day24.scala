import scala.collection.immutable.Queue

object Main extends App {

  case class Point(r: Int, c: Int) {
    def neighbors: Set[Point] =
      Set(Point(r - 1, c), Point(r + 1, c), Point(r, c - 1), Point(r, c + 1))
  }
  case class Move(from: Point, to: Point)

  sealed trait Cell
  case object Wall extends Cell
  case object Open extends Cell
  case class Waypoint(id: Char) extends Cell
  // case class Step(steps: Int) extends Cell

  case class Map(rows: List[List[Cell]]) {
    val waypoints: Set[Point] = (
      rows.zipWithIndex flatMap { case (row, r) =>
        row.zipWithIndex flatMap {
          case (Waypoint(_), c) => Some(Point(r, c))
          case _ => None
        }
      }
    ).toSet

    def visit(waypoint: Waypoint): Map =
      Map(
        rows map { row =>
          row map {
            case `waypoint` => Open
            case other => other
          }
        }
      )

    // def step(nextValue: Int, fromPoints: Set[Point]): Map = {
      // val toPoints = fromPoints flatMap { p => p.neighbors }

      // Map(
        // rows.zipWithIndex map { case (row, r) =>
          // row.zipWithIndex map { case (cell, c) =>
            // if (toPoints contains Point(r, c))
              // cell match {
                // case Open => Step(nextValue)
                // case Step(existingValue) => Step(Math.min(existingValue, nextValue))
                // case Waypoint(_) => Step(nextValue)
                // case cell => cell
              // }
            // else
              // cell
          // }
        // }
      // )
    // }

    def apply(p: Point): Option[Cell] = rows.lift(p.r) flatMap { row => row.lift(p.c) }

    override def toString: String =
      (rows map { row =>
        (row map {
          case Wall => '#'
          case Open => '.'
          case Waypoint(c) => c
        }) mkString ""
      }) mkString "\n"
  }

  case class Problem(map: Map, start: Point, stepsTo: Int) {
    def isSolved: Boolean = map.waypoints.isEmpty
    def subproblem(waypoint: Point, steps: Int): Problem =
      copy(
        map = map.visit(map(waypoint).get.asInstanceOf[Waypoint]),
        start = waypoint,
        stepsTo = stepsTo + steps
      )

    def branches(route: List[Point]): Set[List[Point]] = {
      val nexts: Set[Point] = (
        route.head.neighbors
          filter { p => !(route contains p) }
          filter { p =>
            map(p) match {
              case Some(Open) => true
              case Some(Waypoint(_)) => true
              case _ => false
            }
          }
      )
      nexts map { next => next +: route }
    }

    def subproblems: Set[Problem] = {
      println("Find subproblems for waypoints: " + map.waypoints)

      def toProblems(foundWaypoints: Set[(Point, Int)]): Set[Problem] =
        foundWaypoints map { case (wp, steps) => subproblem(wp, steps) }

      def recurse(
          steps: Int,
          foundWaypoints: Set[(Point, Int)],
          heads: Set[Point],
          visited: Set[Point]
      ): Set[Problem] = {
        if (heads.isEmpty || foundWaypoints.size == map.waypoints.size)
          toProblems(foundWaypoints)
        else {
          val (openHeads, wpHeads) = heads partition { p => map(p) == Some(Open) }
          val nextHeads = (openHeads
            flatMap { p => p.neighbors }
            filter { p => map(p) != Some(Wall) }
            filter { p => !(visited contains p) }
          )

          recurse(
            steps + 1,
            foundWaypoints ++ (wpHeads map { p => (p, steps)}),
            nextHeads,
            visited ++ heads
          )
        }
      }
      recurse(0, Set.empty, Set(start), Set.empty)
    }

    def showFlood(points: Set[Point]): String = {
      (map.rows.zipWithIndex map { case (row, r) =>
          (row.zipWithIndex map { case (cell, c) =>
            if (Point(r, c) == start) 'S'
            else
              cell match {
                case Wall => '#'
                case Open =>
                  if (points contains Point(r, c)) '+'
                  else '.'
                case Waypoint(c) => c
              }
          }) mkString ""
        }) mkString "\n"
    }
  }

  def solve(
      unsolvedProblems: List[Problem],
      bestSolutions: scala.collection.immutable.Map[Point, Problem] = scala.collection.immutable.Map.empty
  ): scala.collection.immutable.Map[Point, Problem] = {
    println(s"Solving ${unsolvedProblems.size} subproblems; found solutions for ${bestSolutions.size} different final waypoints")
    unsolvedProblems match {
      case Nil => bestSolutions
      case problem :: rest =>
        if (problem.map.waypoints.size == 1) {
          val nextBestSolutions: scala.collection.immutable.Map[Point, Problem] = (
            (problem.subproblems ++ bestSolutions.values.toSet)
              groupBy (_.start)
              mapValues { solutions => solutions minBy (_.stepsTo) }
          )

          val currentMaximalMin = nextBestSolutions.values.map(prob => prob.stepsTo).max

          solve(rest filter { prob => prob.stepsTo < currentMaximalMin }, nextBestSolutions)
        } else solve((rest ++ problem.subproblems) sortBy { _.stepsTo }, bestSolutions)
    }
  }

  val map = Map(
    (for {
      line <- io.Source.stdin.getLines
      row = (
        line.trim map {
          case '#' => Wall
          case '.' => Open
          case c => Waypoint(c)
        }
      ).toList
    } yield row).toList
  )

  val startWaypoint = Waypoint('0')
  val startPoint = map.waypoints.find(p => map(p) == Some(startWaypoint)).get

  val solutionsA = solve(List(Problem(map.visit(startWaypoint), startPoint, 0)))

  val mapB = (map.waypoints - startPoint).foldLeft(map) { (map, waypoint) =>
    map.visit(map(waypoint).get.asInstanceOf[Waypoint])
  }
  val solutionsB = solve(
    solutionsA.values.toList
      sortBy { _.stepsTo }
      map { problem =>
        problem.copy(
          map = mapB
        )
      }
  )

  println(s"A: Victory in ${solutionsA.values.map( _.stepsTo).min} steps!")
  println(s"B: Victory in ${solutionsB.values.map( _.stepsTo).min} steps!")
}
