object Main extends App {

  def generate(data: String, targetSize: Int): String = {
    val a = data
    val b = data.reverse map {
      case '0' => '1'
      case '1' => '0'
      case c => c
    }

    val result = a + '0' + b

    if (result.length < targetSize) generate(result, targetSize)
    else result
  }

  def checksum(data: String, targetSize: Int): String = {
    val result = (data
      take targetSize
      grouped 2
      flatMap {
        case "00" => "1"
        case "11" => "1"
        case _ => "0"
      }
    ) mkString ""

    if (result.length % 2 == 0) checksum(result, targetSize)
    else result
  }

  val targetSizeA = 272
  val targetSizeB = 35651584
  val initialState = (io.Source.stdin mkString "").trim

  val solutionA = checksum(generate(initialState, targetSizeA), targetSizeA)
  val solutionB = checksum(generate(initialState, targetSizeB), targetSizeB)

  println("A: " + solutionA)
  println("B: " + solutionB)

}
