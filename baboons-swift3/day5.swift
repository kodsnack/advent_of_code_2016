let input = CommandLine.arguments[1]

print("Warning! MD5 in Swift is super slow - no clue why")

func md5(_ string: String) -> String {
    let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
    var digest = Array<UInt8>(repeating:0, count:Int(CC_MD5_DIGEST_LENGTH))
    CC_MD5_Init(context)
    CC_MD5_Update(context, string, CC_LONG(string.lengthOfBytes(using: String.Encoding.utf8)))
    CC_MD5_Final(&digest, context)
    context.deallocate(capacity: 1)
    var hexString = ""
    for byte in digest {
        hexString += String(format:"%02x", byte)
    }
    return hexString
}

var password = [String](repeating: "", count: 8)

func getPassword(byPosition: Bool) -> String
{
    var i = 0
    var length = 0
    var password = [String](repeating: "", count: 8)

    while length < 8 {
        let hash = md5( String(input + String(i)) )
        if(hash.substring(with: 0..<5) == "00000") {
            if(byPosition) {
                let position = hash.substring(with: 5..<6)
                if(position.isDigit() && Int(position)! < 8) {
                    password[Int(position)!] = (hash.substring(with: 6..<7))
                }
            } else {
                password[length] = hash.substring(with: 5..<6)
            }

            print(password)
            length += 1
        }
        i += 1
    }

    return password.joined()
}

print("Part 1: \(getPassword(byPosition: false))")
print("Part 2: \(getPassword(byPosition: true))")



