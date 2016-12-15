import java.security.MessageDigest

object Main extends App {

  val MD5 = MessageDigest.getInstance("MD5")
  def md5(stretch: Int)(s: String): String =
    md5Raw(s.getBytes, stretch) map ("%02x" format _) mkString ""
  def md5Raw(bytes: Array[Byte], stretch: Int): Array[Byte] = {
    val hash = MD5.digest(bytes)
    if (stretch > 0)
      md5Raw(toHexBytes(hash), stretch - 1)
    else hash
  }

  def toHexBytes(bytes: Array[Byte]): Array[Byte] =
    bytes map { byte =>
      if (byte < 0) byte + 256
      else byte
    } flatMap { int =>
      val hi = (int / 16)
      val lo = (int % 16)
      Array(
        (hi + (if (hi > 9) 87 else 48)).toByte,
        (lo + (if (lo > 9) 87 else 48)).toByte
      )
    }

  val tripletPattern = raw"(.)\1\1".r

  def solve(
      salt: String,
      md5: String => String
  ) : List[(Int, String, String)] = {
    val hashes = Stream from 0 map { nonce => (nonce, md5(salt + nonce)) }
    val matchedHashes = for {
      window <- hashes.sliding(1001)
      (nonce, firstHash) = window.head
      next1000Hashes = window.tail
      triplet <- tripletPattern findFirstIn firstHash map { triplet =>
        println(s"Found triplet ${triplet} at ${nonce}")
        triplet
      }
      pentuplet: String = triplet.head.toString * 5
      (upperMatchNonce, upperMatchHash) <- next1000Hashes find {
        case (nextNonce, nextHash) if nextHash contains pentuplet => {
          println(s"Found pentuplet ${pentuplet} at nonce ${nextNonce}")
          true
        }
        case _ => false
      }
    } yield (nonce, firstHash, upperMatchHash)

    (matchedHashes take targetLength).toList
  }

  val salt = (io.Source.stdin mkString "").trim
  val targetLength = 64

  println()

  println()
  println("Solving A...")
  val solutionA = solve(salt, md5(0))
  println("Solved A:")
  println(solutionA.zipWithIndex map { case ((a,b,c),i) => (i,a,b,c) } mkString "\n")

  println()
  println("Solving B...")
  val solutionB = solve(salt, md5(2016))
  println("Solved B:")
  println(solutionB.zipWithIndex map { case ((a,b,c),i) => (i,a,b,c) } mkString "\n")

  println("Salt: '" + salt + "'")
  println()

  println("A:")
  println(solutionA.length)
  println(solutionA.last)

  println("B:")
  println(solutionB.length)
  println(solutionB.last)

}
