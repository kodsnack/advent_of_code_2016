trait Instruction
case class Cpy(value: String, register: String) extends Instruction
case class Dec(register: String) extends Instruction
case class Inc(register: String) extends Instruction
case class Jnz(value: String, diff: String) extends Instruction
case class Out(value: String) extends Instruction
case class Tgl(offset: String) extends Instruction

case class MachineState(
    program: List[Instruction],
    registers: Map[String, Int],
    eip: Int,
    output: List[Int] = Nil
) {
  def resolve(value: String): Int = registers get value getOrElse value.toInt

  def isFinished: Boolean = !(program.indices contains eip)

  def next: MachineState =
    program(eip) match {
      case Cpy(value, destination) =>
        copy(
          registers =
            if (registers contains destination)
              registers + (destination -> resolve(value))
            else registers
          ,
          eip = eip + 1
        )

      case Inc(register) =>
        copy(
          registers =
            if (registers contains register)
              registers + (register -> (registers(register) + 1))
            else registers
          ,
          eip = eip + 1
        )

      case Dec(register) =>
        copy(
          registers =
            if (registers contains register)
              registers + (register -> (registers(register) - 1))
            else registers
          ,
          eip = eip + 1
        )

      case Jnz(value, diff) =>
        copy(
          eip =
            if (resolve(value) != 0) eip + resolve(diff)
            else (eip + 1)
        )

      case Tgl(offsetArg) => {
        val target = eip + resolve(offsetArg)
        val newProgram =
          if (program.indices contains target)
            program.updated(
              target,
              program(target) match {
                case Cpy(value, destination) => Jnz(value, destination)
                case Inc(register) => Dec(register)
                case Dec(register) => Inc(register)
                case Jnz(value, diff) => Cpy(value, diff)
                case Tgl(offsetArg) => Inc(offsetArg)
                case Out(value) => Inc(value)
              }
            )
          else program
        copy(
          program = newProgram,
          eip = eip + 1
        )
      }

      case Out(value) =>
        copy(
          eip = eip + 1,
          output = output :+ resolve(value)
        )
    }

}


object Main extends App {

  val cpyPattern = raw"cpy (\S+) (\S+)".r
  val incPattern = raw"inc (\S+)".r
  val decPattern = raw"dec (\S+)".r
  val jnzPattern = raw"jnz (\S+) (\S+)".r
  val tglPattern = raw"tgl (\S+)".r
  val outPattern = raw"out (\S+)".r


  val program = (for {
    line <- io.Source.stdin.getLines
    instruction = line.trim match {
      case cpyPattern(value, register) => Cpy(value, register)
      case incPattern(register) => Inc(register)
      case decPattern(register) => Dec(register)
      case jnzPattern(value, diff) => Jnz(value, diff)
      case tglPattern(offset) => Tgl(offset)
      case outPattern(value) => Out(value)
    }
  } yield instruction).toList

  def run(state: MachineState): MachineState = {
    println(s"${state.eip} ${state.registers} ${state.output}")

    state.next match {
      case newState if newState.isFinished || newState.output.length >= 20 => newState
      case newState => run(newState)
    }
  }

  val forcedAddition = 7 * 365
  val startA = findStartA(forcedAddition)
  run(MachineState(program, Map("a" -> startA, "b" -> 0, "c" -> 0, "d" -> 0), 0))
  println(s"Initial a: ${startA}")

  /**
    * d_0 = 0
    * d_1 = 1
    * d_{2n} = 2 * d_{2n - 1}
    * d_{2n + 1} = 2 * d_{2n} + 1
    */
  def dSeries(n: Int): Int =
    if (n <= 2)
      n
    else if (n % 2 == 0)
      2 * dSeries(n - 1)
    else
      2 * dSeries(n - 1) + 1

  def findStartA(forcedAddition: Int): Int =
    (for {
      n <- Stream from 1
      d = dSeries(n)
      if d % 2 == 0
      if d > forcedAddition
    } yield (d - forcedAddition)).head

}
