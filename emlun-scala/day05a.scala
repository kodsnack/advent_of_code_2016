import java.security.MessageDigest

object Main extends App {

  def md5(s: String): Array[Byte] = (
    MessageDigest.getInstance("MD5").digest(s.getBytes)
      take 3
  )

  val line = io.Source.stdin.getLines mkString ""
  val doorId = line.trim()

  var salt = 0
  var length = 0

  while (length < 8) {
    val hash = md5(doorId + salt)
    lazy val candidate = ("%02x" format hash(2)).last

    if (hash(0) == 0 && hash(1) == 0 && hash(2) >= 0 && hash(2) < 16) {
      println(candidate)
      length += 1
    }

    salt += 1
  }

  println()

}
