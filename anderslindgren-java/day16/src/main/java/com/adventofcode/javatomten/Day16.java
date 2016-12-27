package com.adventofcode.javatomten;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.security.NoSuchAlgorithmException;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;


/**
 * Advent of Code 2016-12-16.
 */
public class Day16 {

    private static final int TARGET_LENGTH = 272;
    private String data;

    public static void main(String... args) throws IOException, NoSuchAlgorithmException {
        Day16 day = new Day16();
        List<String> lines = day.parseArgs(args);
        day.parse(lines);
    }


    private List<String> parseArgs(String[] args) throws IOException {
        Path path = FileSystems.getDefault().getPath(args[0]);
        return Files.readAllLines(path);
    }

    private void parse(List<String> lines) throws UnsupportedEncodingException, NoSuchAlgorithmException {
        lines.forEach(this::parseLine);
        solve();
    }

    /**
     *
     * - Call the data you have at this point "a".
     * - Make a copy of "a"; call this copy "b".
     * - Reverse the order of the characters in "b".
     * - In "b", replace all instances of 0 with 1 and all 1s with 0.
     * - The resulting data is "a", then a single 0, then "b".
     * @param line The line to parse
     */
    private void parseLine(String line) {
        String a = line;

        while (a.length() < TARGET_LENGTH) {
            String b = a;
            b = new StringBuilder(b).reverse().toString();
            b = b.chars().mapToObj(i -> (char) i).map(c -> c == '0' ? "1" : "0").collect(Collectors.joining());
            a = a + "0" + b;
        }

        data = a.substring(0, TARGET_LENGTH);
    }


    private void solve() throws NoSuchAlgorithmException, UnsupportedEncodingException {

        System.out.println(data);

        String checksum = checksum(data);
        System.out.println(checksum);
    }

    private String checksum(String data) {
        String result = data;
        while (result.length() % 2 == 0) {
            final String[] split = result.split("(?<=\\G.{2})");
            result = Arrays.stream(split)
                    .map(s -> s.charAt(0) == s.charAt(1) ? "1" : "0")
                    .collect(Collectors.joining());
            System.out.println(result.length() + ": " + result);
        }
        return result;
    }
}
