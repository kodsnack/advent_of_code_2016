object Main extends App {

  sealed trait State {
    def competitors: Int
    def nextState: State
    def prevState: State
    def swordWielder: Int
  }
  case class PreKillState(competitors: Int, swordWielder: Int) extends State {
    def prevState: PostKillState =
      PostKillState(
        competitors,
        (swordWielder + competitors - 1) % competitors
      )

    lazy val victimIndex = (swordWielder + (competitors / 2)) % competitors

    def nextState: PostKillState =
      PostKillState(
        competitors - 1,
        if (victimIndex <= swordWielder) swordWielder - 1 else swordWielder
      )

    override def toString: String = {
      val competitorsString = (1 to competitors).zipWithIndex map {
        case (c, `swordWielder`) => s"*${c}*"
        case (c, `victimIndex`) => s"_${c}_"
        case (c, _) => s" ${c} "
      } mkString " "
      s"Pre  ${competitorsString}"
    }
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

    def nextState: PreKillState =
      PreKillState(
        competitors,
        (swordWielder + 1) % competitors
      )

    override def toString: String = {
      val competitorsString = (1 to competitors).zipWithIndex map {
        case (c, `swordWielder`) => s"*${c}*"
        case (c, _) => s" ${c} "
      } mkString " "
      s"Post ${competitorsString}"
    }
  }

  def solve(targetSize: Int, state: State): State = {
    if (state.competitors >= targetSize) state
    else {
      solve(targetSize, state.prevState)
    }
  }

  def traverseForward(state: State): List[State] =
    if (state.competitors == 1) List(state)
    else state +: traverseForward(state.nextState)

  val finalState = PostKillState(1, 0)
  val competitors = (io.Source.stdin mkString "").trim.toInt

  val initialState = solve(competitors, finalState)

  println("Final state: " + finalState)
  println("Start state killer: " + (initialState.swordWielder + 1))
  println(s"Winner if ${initialState.swordWielder + 1} starts: " + (((competitors - initialState.swordWielder) % competitors) + 1))

}
