object Main extends App {

  val cpyPattern = raw"cpy (\S+) (\S+)".r
  val incPattern = raw"inc (\S+)".r
  val decPattern = raw"dec (\S+)".r
  val jnzPattern = raw"jnz (\S+) (\S+)".r

  trait Instruction
  case class Cpy(value: String, register: String) extends Instruction
  case class Inc(register: String) extends Instruction
  case class Dec(register: String) extends Instruction
  case class Jnz(value: String, diff: Int) extends Instruction

  val program = (for {
    line <- io.Source.stdin.getLines
    instruction = line.trim match {
      case cpyPattern(value, register) => Cpy(value, register)
      case incPattern(register) => Inc(register)
      case decPattern(register) => Dec(register)
      case jnzPattern(value, diff) => Jnz(value, diff.toInt)
    }
  } yield instruction).toList

  def runStep(program: List[Instruction], registers: Map[String, Int], eip: Int): (Map[String, Int], Int) =
    program(eip) match {
      case Cpy(value, destination) => {
        val newRegisters = if (registers contains value) {
          registers + (destination -> registers(value))
        } else {
          registers + (destination -> value.toInt)
        }
        (newRegisters, eip + 1)
      }

      case Inc(register) => (registers + (register -> (registers(register) + 1)), eip + 1)
      case Dec(register) => (registers + (register -> (registers(register) - 1)), eip + 1)

      case Jnz(value, diff) =>
        if (registers contains value)
          (registers, if (registers(value) != 0) eip + diff else eip + 1)
        else
          (registers, if (value.toInt != 0) eip + diff else eip + 1)
    }

  def run(program: List[Instruction], registers: Map[String, Int], eip: Int): Map[String, Int] =
    runStep(program, registers, eip) match {
      case (newRegisters, newEip) if program.indices contains newEip => run(program, newRegisters, newEip)
      case (result, _) => result
    }

  println("A:\n" + (run(program, Map("a" -> 0, "b" -> 0, "c" -> 0, "d" -> 0), 0) mkString "\n"))
  println()
  println("B:\n" + (run(program, Map("a" -> 0, "b" -> 0, "c" -> 1, "d" -> 0), 0) mkString "\n"))

}
