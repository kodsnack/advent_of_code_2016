package com.adventofcode.javatomten;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.security.NoSuchAlgorithmException;
import java.util.List;


/**
 * Advent of Code 2016-12-19.
 */
public class Day19 {


    public static void main(String... args) throws IOException, NoSuchAlgorithmException {
        Day19 day = new Day19();
        List<String> lines = day.parseArgs(args);
        day.parse(lines.get(0));
    }

    private List<String> parseArgs(String[] args) throws IOException {
        Path path = FileSystems.getDefault().getPath(args[0]);
        return Files.readAllLines(path);
    }

    private void parse(String line) throws UnsupportedEncodingException, NoSuchAlgorithmException {
        final long input = Long.parseLong(line);

        final String s = Long.toBinaryString(input);
        final char msb = s.charAt(0);
        final String tmp = s.substring(1, s.length()) + msb;
        final long result = Long.parseLong(tmp, 2);
        System.out.println(result);
    }

}
