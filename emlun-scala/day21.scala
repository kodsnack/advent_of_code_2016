object Main extends App {

  val swapPositionPattern = raw"swap position (\d+) with position (\d+)".r
  val swapLetterPattern = raw"swap letter (.) with letter (.)".r
  val rotateLeftPattern = raw"rotate left (\d+) steps?".r
  val rotateRightPattern = raw"rotate right (\d+) steps?".r
  val rotateDynamicPattern = raw"rotate based on position of letter (.)".r
  val reverseSlicePattern = raw"reverse positions (\d+) through (\d+)".r
  val moveIndexPattern = raw"move position (\d+) to position (\d+)".r

  def moveIndex(state: String, x: Int, y: Int): String = {
    val without = state.take(x.toInt) ++: state.drop(x.toInt + 1)
    without.take(y.toInt) ++: state(x.toInt) +: without.drop(y.toInt)
  }

  def reverseSlice(state: String, x: Int, y: Int): String =
    state.patch(x, state.slice(x, y + 1).reverse, (y + 1 - x))

  def rotateDynamic(state: String, letter: String): String = {
    val index = state indexOf letter
    val steps = (index + (if (index >= 4) 2 else 1)) % state.length
    state.takeRight(steps) ++ state.dropRight(steps)
  }

  def rotateLeft(state: String, steps: Int): String =
    state.drop(steps.toInt) ++: state.take(steps.toInt)

  def rotateRight(state: String, steps: Int): String =
    state.takeRight(steps.toInt) ++ state.dropRight(steps.toInt)

  def swapLetter(state: String, x: Char, y: Char): String =
    state map {
      case `x` => y
      case `y` => x
      case c => c
    }

  def swapPosition(state: String, x: Int, y: Int): String = {
    val xIndex = x.toInt
    val yIndex = y.toInt
    val (xValue, yValue) = (state(xIndex), state(yIndex))
    state.updated(xIndex, yValue).updated(yIndex, xValue)
  }

  def solve(instructions: List[String], initialState: String): String =
    instructions.foldLeft(initialState) { (state, instruction) =>
      instruction match {
        case swapPositionPattern(x, y)    => swapPosition(state, x.toInt, y.toInt)
        case swapLetterPattern(x, y)      => swapLetter(state, x.head, y.head)
        case rotateLeftPattern(steps)     => rotateLeft(state, steps.toInt)
        case rotateRightPattern(steps)    => rotateRight(state, steps.toInt)
        case rotateDynamicPattern(letter) => rotateDynamic(state, letter)
        case reverseSlicePattern(x, y)    => reverseSlice(state, x.toInt, y.toInt)
        case moveIndexPattern(x, y)       => moveIndex(state, x.toInt, y.toInt)
        case _ => ???
      }
    }

  def solveBackward(instructions: List[String], finalState: String): String =
    instructions.reverse.foldLeft(finalState) { (state, instruction) =>
      instruction match {
        case swapPositionPattern(x, y)    => swapPosition(state, x.toInt, y.toInt)
        case swapLetterPattern(x, y)      => swapLetter(state, x.head, y.head)
        case rotateLeftPattern(steps)     => rotateRight(state, steps.toInt)
        case rotateRightPattern(steps)    => rotateLeft(state, steps.toInt)
        case rotateDynamicPattern(letter) => (
          (0 until state.length)
            map { steps => rotateLeft(state, steps) }
            find { preState => rotateDynamic(preState, letter) == state }
        ).get
        case reverseSlicePattern(x, y)    => reverseSlice(state, x.toInt, y.toInt)
        case moveIndexPattern(y, x)       => moveIndex(state, x.toInt, y.toInt)
        case _ => ???
      }
    }

  val initialStateA = "abcdefgh"
  val initialStateB = "fbgdceah"

  val instructions = (for {
    line <- io.Source.stdin.getLines
    instruction = line.trim
  } yield instruction).toList

  println("A: " + solve(instructions, initialStateA))
  println("B: " + solveBackward(instructions, initialStateB))

}
