//
//  md5.swift
//  
//  Advent of code, day 3, puzzle 1 & 2
//  Calculate MD5 hashes on a string with an increasing number appended.
//  Puzzle 1: If the first five positions of the hexadecimal hash are zeros,
//  add the sixth position to the key.
//  Puzzle 2: If the first five positions of the hexadecimal hash are zeros,
//  treat the sixth digit as the position in the key where to insert the seventh hex digit.
//
//  Created by Iggy Drougge on 2016-12-05.
//
//
import Cocoa
import Foundation

infix operator <<< {associativity none precedence 160}  // Left rotation (or cyclic shift) operator
private func <<< (lhs:uint32, rhs:uint32) -> uint32 {
    return lhs << rhs | lhs >> (32-rhs)
}

public struct MD5 {
    private static let CHUNKSIZE=16
    // MD5 magic words
    private static let a0:uint32 = 0x67452301
    private static let b0:uint32 = 0xEFCDAB89
    private static let c0:uint32 = 0x98BADCFE
    private static let d0:uint32 = 0x10325476
    private static let shifts:[uint32] = [7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22,
                                          5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20,
                                          4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23,
                                          6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21]
    private static let k:[uint32] = [0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee, 0xf57c0faf, 0x4787c62a, 0xa8304613, 0xfd469501,
                                     0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be, 0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821,
                                     0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa, 0xd62f105d, 0x2441453,  0xd8a1e681, 0xe7d3fbc8,
                                     0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed, 0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a,
                                     0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c, 0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70,
                                     0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x4881d05,  0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665,
                                     0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039, 0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1,
                                     0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1, 0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391]
    /**************************************************
     * MD5.context                                   *
     * The context struct contains volatile variables *
     * as well as the actual hashing function.        *
     **************************************************/
    private struct context {
        // Initialise variables:
        var h:[uint32]=[MD5.a0,MD5.b0,MD5.c0,MD5.d0]
        
        // Process one chunk of 16 big-endian longwords
        private mutating func processChunk(inout chunk:[uint32]) {
            
            // Initialise hash value for this chunk:
            var a,b,c,d,f,g:uint32
            a=h[0]; b=h[1]; c=h[2]; d=h[3]
            f=0x0; g=0
            
            // Main loop
            for i:uint32 in 0...63 {
                switch i {
                case 0...15:
                    f = (b & c) | ((~b) & d)
                    g = i
                case 16...31:
                    f = (d & b) | (~d & c)
                    g = (5 * i + 1) % 16
                case 32...47:
                    f = b ^ c ^ d
                    g = (3 * i + 5) % 16
                case 48...63:
                    f = c ^ (b | ~d)
                    g = (7 * i) % 16
                default: break
                }
                let dtemp = d
                d = c
                c = b
                b = b &+ (a &+ f &+ MD5.k[Int(i)] &+ chunk[Int(g)]) <<< MD5.shifts[Int(i)]
                a = dtemp
                //print(String(format: "t=%d %08X %08X %08X %08X %08X", i, a, b, c, d, e))
            }
            
            // Add this chunk's hash to result so far:
            h[0] = h[0] &+ a
            h[1] = h[1] &+ b
            h[2] = h[2] &+ c
            h[3] = h[3] &+ d
        }
    }
    
    /**************************************************
     * processData()                                  *
     * All inputs are processed as NSData.            *
     * This function splits the data into chunks of   *
     * 16 longwords (64 bytes, 512 bits),             *
     * padding the chunk as necessary.                *
     **************************************************/
    private static func processData(data:NSData) -> MD5.context? {
        var context=MD5.context()
        var w = [uint32](count: CHUNKSIZE, repeatedValue: 0x00000000)   // Initialise empty chunk
        let ml = data.length << 3                                       // Message length in bits
        data.getBytes(&w, length: 64)                                   // Retrieve a chunk
        var range = NSMakeRange(0, 64)                                  // A chunk is 64 bytes
        data.length
        // If the remainder of the message is more than 64 bytes
        while data.length > NSMaxRange(range) {
            data.getBytes(&w, range: range)                             // Retrieve one chunk
            context.processChunk(&w)                                    // Process the chunk
            range = NSMakeRange(NSMaxRange(range), 64)                  // Make range for next chunk
        }
        
        // Handle remainder of message that is <64 bytes in length
        //w=[uint32](count: CHUNKSIZE, repeatedValue: 0x00000000)       // Initialise empty chunk
        range = NSMakeRange(range.location, data.length-range.location) // Range for remainder of message
        data.getBytes(&w, range: range)                                 // Retrieve remainder
        let bytetochange = range.length % strideof(uint32)              // The bit to the right of the
        let shift = uint32(bytetochange << 3)                           // last bit of the actual message
        w[range.length/strideof(uint32)] |= 0x80 << shift               // should be set to 1.
        // If the remainder overflows, a new, empty chunk must be added
        if range.length+1 > 56 {
            context.processChunk(&w)
            w=[uint32](count: CHUNKSIZE, repeatedValue: 0x00000000)
        }
        
        // The last 64 bits of the last chunk must contain the message length in big-endian format
        w[14] = uint32(ml)
        context.processChunk(&w)                                    // Process the last chunk
        
        // The context (or nil) is returned, containing the hash in the h[] array
        return context
    }
    
    /**************************************************
     * hexString()                                    *
     * Render the hash as a hexadecimal string        *
     **************************************************/
    private static func hexString(context:MD5.context?) -> String? {
        guard let c=context else {return nil}
        var hh:String=""
        c.h.forEach{hh+=String(format:"%08X\($0.distanceTo(c.h.last!)==0 ? "":" ")",$0.bigEndian)}
        return hh
        //return String(format: "%8X %8X %8X %8X %8X", c.h[0], c.h[1], c.h[2], c.h[3], c.h[4])
    }
    
    /**************************************************
     * PUBLIC METHODS                                 *
     **************************************************/
    
    /// Return a hexadecimal hash from a string
    public static func hexStringFromString(str:String) -> String? {
        return hexString(processData(str.dataUsingEncoding(NSUTF8StringEncoding)!))
    }
    
    /// Return the hash of a string as an array of Ints
    public static func hashFromString(str:String) -> [Int]? {
        return processData(str.dataUsingEncoding(NSUTF8StringEncoding)!)?.h.map{Int($0.bigEndian)}
    }
}

var key = "uqwqemis"
var found = 0
var code1 = ""
var code2 = [String?](count: 8, repeatedValue: nil)
var i = 0
repeat {
    let hash = MD5.hashFromString("\(key)\(i)")![0]
    if hash & 0xFFFFF000 == 0 {
        print("\(i): \(MD5.hexStringFromString("\(key)\(i)"))")
        let position = (hash & 0x00000F00) >> 8
        code1 = code1 + ":" + String(format:"%0X", (hash & 0x00000F00) >> 8)
        if position < 8 && code2[position] == nil {
            code2[position] = String(format:"%0X", (hash & 0x000000F0) >> 4)
            found += 1
        }
        print("keys found:", found)
    }
    i += 1
} while found < 8
print(code1)
print(code2.flatMap{$0})
