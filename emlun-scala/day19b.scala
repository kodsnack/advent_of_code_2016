object Main extends App {

  sealed trait State {
    def competitors: Int
    def prevState: State
    def swordWielder: Int
  }

  case class PreKillState(competitors: Int, swordWielder: Int) extends State {
    def prevState: PostKillState =
      PostKillState(
        competitors,
        (swordWielder + competitors - 1) % competitors
      )
  }

  case class PostKillState(competitors: Int, swordWielder: Int) extends State {
    val victimIndex =
      ((swordWielder + (competitors / 2) + (competitors % 2)) % competitors) match {
        case 0 => competitors
        case i => i
      }

    def prevState: PreKillState =
      PreKillState(
        competitors + 1,
        swordWielder + (if (victimIndex <= swordWielder) 1 else 0)
      )
  }

  def solve(targetSize: Int, state: State): State =
    if (state.competitors >= targetSize) state
    else solve(targetSize, state.prevState)

  val finalState = PostKillState(1, 0)
  val competitors = (io.Source.stdin mkString "").trim.toInt

  val initialState = solve(competitors, finalState)

  println("Final state: " + finalState)
  println("Start state killer: " + (initialState.swordWielder + 1))
  println(s"Winner if ${initialState.swordWielder + 1} starts: " + (((competitors - initialState.swordWielder) % competitors) + 1))

}
