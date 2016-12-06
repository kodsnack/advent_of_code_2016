package com.adventofcode.javatomten;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.List;

/**
 * Advent of Code 2016-12-04.
 */
public class Day5 {

    public static void main(String... args) throws IOException, NoSuchAlgorithmException {
        Day5 day = new Day5();
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
            StringBuilder result = new StringBuilder();
            for (int i = 0; i < 10000000; i++) {
                byte[] digest = md.digest((line + i).getBytes("UTF-8"));

                StringBuilder sb = new StringBuilder();
                for (byte aDigest : digest) {
                    sb.append(Integer.toHexString((aDigest & 0xFF) | 0x100).substring(1, 3));
                }
                final String x = sb.toString();
                if (x.startsWith("00000")) {
                    result.append(x.charAt(5));
                }
                if (result.length() == 8) {
                    break;
                }
            }
            System.out.println(result.toString());
        }
    }
}
