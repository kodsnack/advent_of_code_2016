import java.security.MessageDigest

object Main extends App {

  val targetLength = 8
  def md5(s: String): Array[Byte] = (
    MessageDigest.getInstance("MD5").digest(s.getBytes)
      take 3
  )

  def pad(password: String) =
    password + ("_" * (targetLength - password.length))

  val line = io.Source.stdin.getLines mkString ""
  val doorId = line.trim()

  var salt: Int = 0
  var password = ""

  while (password.length < targetLength) {
    val hash = md5(doorId + salt)
    lazy val candidate = ("%02x" format hash(2)).last

    if (hash(0) == 0 && hash(1) == 0 && hash(2) >= 0 && hash(2) < 16) {
      println(pad(password + candidate) + " " + salt)
      password += candidate
    }

    salt += 1
  }

  println()
  println(password)

}
