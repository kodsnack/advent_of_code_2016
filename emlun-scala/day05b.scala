import java.security.MessageDigest

object Main extends App {

  val targetLength = 8
  def md5(s: String): Array[Byte] = (
    MessageDigest.getInstance("MD5").digest(s.getBytes)
      take 4
  )

  val line = io.Source.stdin.getLines mkString ""
  val doorId = line.trim()

  var salt = 0
  var password: Map[Int, Char] = Map.empty

  while (password.size < targetLength) {
    val hash = md5(doorId + salt)
    val index = hash(2).toInt

    if (
        hash(0) == 0
        && hash(1) == 0
        && index >= 0
        && index < targetLength
        && !(password contains index)
    ) {
      val index = hash(2).toInt
      val char = ("%02x" format hash(3)).head

      password = password + (index -> char)
      println(s"${index} ${char}")
    }

    salt += 1
  }

  println(password.keySet.toList.sorted map (password(_)) mkString "")

}
