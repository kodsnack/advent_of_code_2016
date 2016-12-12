import java.security.MessageDigest

object Main extends App {

  val targetLength = 8
  def md5(s: String): Array[Byte] = (
    MessageDigest.getInstance("MD5").digest(s.getBytes)
      take 4
  )

  def pad(password: Map[Int, Char]) = (
    0 until targetLength
      map (i =>
        password
          get i
          getOrElse "_"
      )
      mkString ""
  )

  val line = io.Source.stdin.getLines mkString ""
  val doorId = line.trim()

  var salt = 0
  var password: Map[Int, Char] = Map.empty

  while (password.size < targetLength) {
    val hash = md5(doorId + salt)
    val index = hash(2)

    if (
        hash(0) == 0
        && hash(1) == 0
        && index >= 0
        && index < targetLength
        && !(password contains index)
    ) {
      val char = ("%02x" format hash(3)).head

      password = password + (index.toInt -> char)
      println(pad(password))
    }

    salt += 1
  }

  println()
  println(pad(password))

}
