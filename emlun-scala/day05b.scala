import java.security.MessageDigest

object Main extends App {

  def md5(s: String): String = (
    MessageDigest.getInstance("MD5").digest(s.getBytes)
      take 4
      map ("%02x" format _)
      mkString ""
  )

  val line = io.Source.stdin.getLines mkString ""
  val doorId = line.trim()

  var salt = 0
  var password: Map[Int, Char] = Map.empty

  while (password.size < 8) {
    val hash = md5(doorId + salt)

    if (hash.take(5) == "00000" && hash(5) >= '0' && hash(5) <= '9') {
      val index = hash(5).toString.toInt

      println(s"${salt} ${hash(5)} ${hash(6)}")

      if (index >= 0 && index < 8 && !(password contains index)) {
        password = password + (index -> hash(6))
        println(s"${index} ${hash(6)}")
      }
    }

    salt += 1
  }

  println(password.keySet.toList.sorted map (password(_)) mkString "")

}
