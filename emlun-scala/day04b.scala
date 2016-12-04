object Main extends App {

  val searchKeyword = "pole"

  val alphabet = "abcdefghijklmnopqrstuvwxyz"
  def decipher(char: Char, key: Int): Char =
    if (char == '-') ' '
    else alphabet(((alphabet indexOf char) + key) % alphabet.length)
  def decipher(ciphertext: String, key: Int): String = ciphertext map { decipher(_, key) }

  for {
    line <- io.Source.stdin.getLines
    dashGroups = (line.trim split "-").toList
    lastGroups = (dashGroups.last split raw"\[").toList

    roomName = dashGroups.init mkString "-"
    sectorId = lastGroups(0).toInt
    checksum = lastGroups(1).init

    roomNameChars = (roomName.toSet - '-').toList
    expectedChecksum = (
      roomNameChars
        sortWith { (c1, c2) =>
          val count1 = roomName count (_ == c1)
          val count2 = roomName count (_ == c2)

          if (count1 > count2)
            true
          else if (count2 > count1)
            false
          else if (c1 < c2)
            true
          else
            false
        }
        take 5
        mkString ""
    )

    if checksum == expectedChecksum
    decryptedName = decipher(roomName, sectorId)

    if decryptedName contains searchKeyword
  } {
    println(s"${sectorId} ${decryptedName}")
  }

}
