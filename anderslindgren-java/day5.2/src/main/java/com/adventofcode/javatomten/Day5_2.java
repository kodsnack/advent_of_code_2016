package com.adventofcode.javatomten;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Arrays;
import java.util.List;

/**
 * Advent of Code 2016-12-06.
 */
public class Day5_2 {

    public static void main(String... args) throws IOException, NoSuchAlgorithmException {
        Day5_2 day = new Day5_2();
        List<String> lines = day.parseArgs(args);
        day.parse(lines);
    }

    private List<String> parseArgs(String[] args) throws IOException {
        Path path = FileSystems.getDefault().getPath(args[0]);
        return Files.readAllLines(path);
    }


    private void parse(List<String> lines) throws NoSuchAlgorithmException, UnsupportedEncodingException {
        MessageDigest md = MessageDigest.getInstance("MD5");
        for (String line : lines) {
            char[] result = "        ".toCharArray();
            for (int i = 0; i < 100000000; i++) {
                byte[] digest = md.digest((line + i).getBytes("UTF-8"));

                StringBuilder sb = new StringBuilder();
                for (byte aDigest : digest) {
                    sb.append(Integer.toHexString((aDigest & 0xFF) | 0x100).substring(1, 3));
                }
                final String x = sb.toString();
                if (x.startsWith("00000")) {
                    System.out.println("Found: " + x);
                    if (Character.isDigit(x.charAt(5))) {
                        final int offset = Integer.parseInt("" + x.charAt(5));
                        final char value = x.charAt(6);
                        System.out.println("Result: " + new String(result));
                        if (offset < 8 && !Character.isLetterOrDigit(result[offset])) {
                            System.out.printf("%d: %c isTaken: %b", offset, value, Character.isLetterOrDigit(result[offset]));
                            result[offset] = value;
                            System.out.println(new String(result));
                        }
                    }
                }
//                if (Arrays.stream(result).mapToObj(p -> (char) p).filter(Character::isLetterOrDigit).count() == 8) {
//                    break;
//                }
            }
            System.out.println(new String(result));
        }
    }
}
