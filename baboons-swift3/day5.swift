let input = CommandLine.arguments[1]

func md5(_ string: String) -> Array<UInt8> {
    let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
    var digest = Array<UInt8>(repeating:0, count:Int(CC_MD5_DIGEST_LENGTH))
    CC_MD5_Init(context)
    CC_MD5_Update(context, string, CC_LONG(string.lengthOfBytes(using: String.Encoding.utf8)))
    CC_MD5_Final(&digest, context)
    context.deallocate(capacity: 1)

    return digest
}

func validDigest(_ digest: Array<UInt8>) -> Bool {
    return digest[0] == 0 && digest[1] == 0 && String(digest[2], radix: 16).characters.count == 1
}

func digestToHex(_ digest: Array<UInt8>) -> String {
    var hexString = ""

    for byte in digest {
        let hex = String(byte, radix: 16)
        hexString += hex.characters.count == 1 ? "0" + hex : hex
    }

    return hexString
}

var i = 0
var password1 = [String](repeating: "", count: 8)
var password2 = [String](repeating: "", count: 8)
var pos1 = 0
var pos2 = 0

while pos1 < 8 || pos2 < 8 {
    let digest = md5( String(input + String(i)) )

    if(validDigest(digest)) {
        let hash = digestToHex(digest)
        let position = Int(hash.substring(with: 5..<6)) ?? 10

        if(position < 8 && password2[position].isEmpty) {
            password2[position] = (hash.substring(with: 6 ..< 7))
            pos2 += 1
        }

        if(pos1 < 8) {
            password1[pos1] = hash.substring(with: 5..<6)
            pos1 += 1
        }
    }
    i += 1
}

print("Part 1: \(password1.joined())")
print("Part 2: \(password2.joined())")

