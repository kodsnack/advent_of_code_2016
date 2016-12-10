object Main extends App {

  val searchLow = 17
  val searchHigh = 61

  sealed trait AcceptorId { val id: String }
  case class Bot(id: String) extends AcceptorId
  case class Output(id: String) extends AcceptorId

  case class Assign(value: Int, bot: Bot)
  case class Give(id: Bot, low: AcceptorId, high: AcceptorId)

  type State = Map[AcceptorId, (Option[Int], Option[Int])]

  val instructions: Iterator[(Option[Assign], Option[Give])] = for {
    line <- io.Source.stdin.getLines
    words = line.trim split raw"\s+"
    instruction = words match {
      case Array("value", value, "goes", "to" ,"bot", botId) => Left(Assign(value.toInt, Bot(botId)))
      case Array("bot", botId, "gives", "low", "to", lowType, lowId, "and", "high", "to", highType, highId) =>
        Right(Give(
          Bot(botId),
          lowType match {
            case "bot" => Bot(lowId)
            case "output" => Output(lowId)
          },
          highType match {
            case "bot" => Bot(highId)
            case "output" => Output(highId)
          }
        ))
    }
    assignment = instruction.left.toOption
    give = instruction.right.toOption
  } yield (assignment, give)

  val (assignments: List[Assign], botInstructions: Map[Bot, Give]) =
    instructions.toList.unzip match {
      case (a, b) => (a.flatten, b.flatten.map(give => (give.id -> give)).toMap)
    }

  def run(
      botInstructions: Map[Bot, Give],
      assignments: List[Assign],
      initialState: State
  ): State = {
    def give(value: Int, acceptor: AcceptorId, state: State): State =
      acceptor match {
        case Output(id) =>
          state(acceptor) match {
            case (None, None) => state + (acceptor -> (Some(value), None))
            case value => throw new Exception(s"Output ${id} is already set to ${value}")
          }

        case acceptorBot: Bot =>
          state(acceptor) match {
            case (None, None) =>
              state + (acceptor -> (Some(value), None))

            case (Some(first), None) =>
              updateState(
                Math.min(first, value),
                Math.max(first, value),
                botInstructions(acceptorBot),
                state + (acceptor -> (Some(first), Some(value)))
              )

            case value => throw new Exception(s"Bot ${acceptorBot.id} already has two values: ${value}")
          }
      }

    def updateState(low: Int, high: Int, instruction: Give, state: State): State =
      give(
        low,
        instruction.low,
        give(high, instruction.high, state)
      )

    assignments.foldLeft(initialState) { (state, assignment) =>
      give(assignment.value, assignment.bot, state)
    }
  }

  val initialState: State = botInstructions flatMap {
    case (bot, Give(_, low, high)) =>
      Map(bot -> (None, None), low -> (None, None), high -> (None, None))
  }

  val finalState = run(botInstructions, assignments, initialState)

  val soughtBot = finalState find {
    case (_: Bot, (Some(`searchLow`), Some(`searchHigh`))) => true
    case (_: Bot, (Some(`searchHigh`), Some(`searchLow`))) => true
    case _ => false
  }
  println(s"Sought bot: ${soughtBot.get._1.id} - state: ${soughtBot.get._2}")

  val outputProduct = finalState.foldLeft(1) { (product, entity) =>
    entity match {
      case (Output("0" | "1" | "2"), (Some(value), _)) => product * value
      case _ => product
    }
  }
  println("Output product: " + outputProduct)
}
