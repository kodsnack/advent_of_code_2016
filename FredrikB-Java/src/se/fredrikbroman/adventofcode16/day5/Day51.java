package se.fredrikbroman.adventofcode16.day5;

import java.security.*;
import java.io.*;
import org.apache.commons.codec.binary.Hex;

public class Day51 {
    public static void main(String[] args) {
        String doorId = "";
        String passcode = "";
        int i = 0;
        int j = 0;

        while(true) {

            try {
                doorId = args[0] + i;
            }
            catch(ArrayIndexOutOfBoundsException aio) {
                System.out.println("java Day51 <door ID>");
                System.exit(1);
            }
            
            String hex = createHash(doorId);
            
            if(isValid(hex)) {
                try {
                    passcode += hex.substring(5,6);
                    j++;
                }
                catch(StringIndexOutOfBoundsException e) {
                    ; // Empty on purpose
                }
            }
            
            if (j >= 8) {
                System.out.println(passcode);
                System.exit(0);
            }

            i++;
        }
    }

    private static boolean isValid(String s) {
        return s.startsWith("00000");
    }

    private static String createHash(String doorId) {
        try {
            byte[] bytesOfMessage = doorId.getBytes("UTF-8");
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] theDigest = md.digest(bytesOfMessage);
            return Hex.encodeHexString(theDigest);
        }
        catch(UnsupportedEncodingException|NoSuchAlgorithmException e) {
            System.out.println(e);
            return "Error";
        }
    }
}

