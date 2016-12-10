/* Advent of Code - Day 5 - How About a Nice Game of Chess? */

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class Day5 {

    public static void main(String[] args) {

        long start = System.currentTimeMillis();

        String doorID = "reyedfim";
        String password = "";
        int index = 0;

        while (password.length() != 8) {
            String p = doorID + index;
            String hash = getMD5(p);
            String zeroes = hash.substring(0, 5);
            if (zeroes.equals("00000")) {
                password += hash.charAt(5);

            }

            index += 1;

        }

        System.out.println(password);
        long end = System.currentTimeMillis();
        long ms = end - start;
        long sec = ms / 1000;
        System.out.println("Program finished in: ");
        System.out.println(ms + " ms");
        System.out.println(sec + " sec");


    }

    public static String getMD5(String doorID) {
        byte[] buffer = doorID.getBytes();
        byte[] result = null;
        StringBuffer sbuf = null;
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");

            result = new byte[md.getDigestLength()];

            md.reset();
            md.update(buffer);

            result = md.digest();

            sbuf = new StringBuffer(result.length * 2);

            for (int i = 0; i < result.length; i++) {
                int intval = result[i] & 0xff;
                if (intval < 0x10) {
                    sbuf.append("0");
                }
                sbuf.append(Integer.toHexString(intval).toUpperCase());
            }

        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }

        return sbuf.toString();
    }

}
