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
  var length = 0

  while (length < 8) {
    val hash = md5(doorId + salt)

    if (hash.take(5) == "00000") {
      print(hash(5))
      length += 1
    }

    salt += 1
  }

  println()

}
