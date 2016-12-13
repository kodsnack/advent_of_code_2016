import scala.collection.immutable.Queue

sealed trait Entity
case class Chip(kind: String) extends Entity
case class Generator(kind: String) extends Entity

case class FloorState(entities: Set[Entity] = Set.empty) {
  lazy val isValid: Boolean = {
    val (chips, generators) = entities partition (_.isInstanceOf[Chip])
    generators.isEmpty || (chips forall {
      case Chip(kind) => generators contains Generator(kind)
      case _ => ???
    })
  }

  def repr: String = entities mkString " "
}
case class State(floors: List[FloorState], elevatorFloor: Int = 0)(val moves: List[Move] = Nil) {
  val isValid: Boolean = floors forall (_.isValid)
  lazy val isFinished: Boolean = floors.init.forall (_.entities.isEmpty)

  def move(move: Move): Option[State] = {
    val nextElevatorFloor = elevatorFloor + (if (move.up) 1 else -1)
    floors.lift(nextElevatorFloor) flatMap { otherFloor =>
      val newCurrentFloor = FloorState(floors(elevatorFloor).entities - move.movee1 -- move.movee2)
      val newOtherFloor = FloorState(otherFloor.entities + move.movee1 ++ move.movee2)

      val newState = State(
        floors.zipWithIndex map {
          case (_, `elevatorFloor`) => newCurrentFloor
          case (_, `nextElevatorFloor`) => newOtherFloor
          case (floor, _) => floor
        },
        nextElevatorFloor
      )(moves :+ move)

      if (newState.isValid) Some(newState)
      else None
    }
  }

  def repr: String = floors.zipWithIndex.reverse map { case (floor, index) =>
    s"F${index + 1} ${if (index == elevatorFloor) "E" else " "} ${floor.repr}"
  } mkString "\n"
}
case class Move(movee1: Entity, movee2: Option[Entity], up: Boolean) {
  override def toString: String =
    s"Move ${movee1}${movee2 map (" and " + _) getOrElse ""} ${if (up) "up" else "down"}"
}

object Main extends App {

  val floorPattern = raw"The (\S+) floor contains (.*)".r
  val nothingPattern = raw"nothing relevant.".r
  val componentSeparatorPattern = raw"\s*(,|and)\s*".r
  val chipPattern = raw"an?\s+(\S+)-compatible microchip.?".r
  val generatorPattern = raw"an?\s+(\S+) generator.?".r

  val initialState = State(
    (for {
      line <- io.Source.stdin.getLines
      entities = line.trim match {
        case floorPattern(floor, rest) =>
          (componentSeparatorPattern split rest)
            .flatMap {
              case chipPattern(kind) => Some(Chip(kind))
              case generatorPattern(kind) => Some(Generator(kind))
              case nothingPattern => None
            }
      }
      floor = FloorState(entities.toSet)
    } yield floor).toList
  )()

  def search(
      state: State,
      prevStates: Set[State] = Set.empty,
      nextStates: Queue[State] = Queue.empty,
      searchStep: Int = 0
  ): Option[State] = {
    if (searchStep % 10000 == 0) {
      println(s"Searching... ${state.moves.length} steps at iteration ${searchStep}")
    }
    if (state.isFinished) {
      Some(state)
    } else if (prevStates contains state) {
      nextStates.dequeueOption match {
        case None => None
        case Some((nextState, nextNextStates)) =>
          search(nextState, prevStates, nextNextStates, searchStep + 1)
      }
    } else {
      val possibleNextStates = for {
        numMovees <- List(1, 2)
        up <- List(true, false)
        movees <- state.floors(state.elevatorFloor).entities.subsets(numMovees)
        move = Move(movees.head, movees.tail.headOption, up)
        nextState <- state.move(move)
        if nextState.isValid
        if !(prevStates contains nextState)
      } yield nextState

      (nextStates enqueue possibleNextStates).dequeueOption match {
        case None => None
        case Some((nextState, nextNextStates)) =>
          search(nextState, prevStates + state, nextNextStates, searchStep + 1)
      }
    }
  }

  println("Initial state")
  println(initialState.repr)
  println("Valid: " + initialState.isValid)
  println()

  search(initialState) match {
    case Some(finalState) => {
      println()
      println("Winning sequence:")

      val stateSequence = finalState.moves.scanLeft(initialState) { (state, move) =>
        state.move(move).get
      } drop 1

      (finalState.moves zip stateSequence) foreach { case (move, state) =>
        println()
        println(s"${state.moves.length}: ${move}")
        println(state.repr)
      }

      println()
      println(finalState.moves.length + " steps")
      println((finalState.moves.length + 24) + " steps with two more pairs of chip and generator")
    }
    case None => {
      println("No winning sequence found. :(")
    }
  }

}
