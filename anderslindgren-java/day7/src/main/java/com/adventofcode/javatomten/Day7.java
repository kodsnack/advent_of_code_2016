package com.adventofcode.javatomten;

import java.io.IOException;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

import static java.lang.Character.isAlphabetic;

/**
 * Advent of Code 2016-12-07.
 */
public class Day7 {

    public static void main(String... args) throws IOException {
        Day7 day = new Day7();
        List<String> lines = day.parseArgs(args);
        day.parse(lines);
    }

    private List<String> parseArgs(String[] args) throws IOException {
        Path path = FileSystems.getDefault().getPath(args[0]);
        return Files.readAllLines(path);
    }


    private void parse(List<String> lines) {
        int tlsable = 0;
        for (final String line : lines) {
            if (checkTLS(line)) {
                tlsable++;
            }
        }
        System.out.println(tlsable);
    }

    private boolean checkTLS(String line) {
        final char[] c = line.toCharArray();
        boolean isTLS = false;
        boolean inHypernet = false;
        for (int i = 0; i < c.length - 3; i++) {
            if (c[i] == '[') {
                inHypernet = true;
            } else if (c[i] == ']') {
                inHypernet = false;
            }
            if (isChars(c[i], c[i + 1], c[i + 2], c[i + 3])
                    && isABBA(c[i], c[i + 1], c[i + 2], c[i + 3])) {
                if (!inHypernet) {
                    isTLS = true;
                } else {
                    isTLS = false;
                    break;
                }
            }
        }
        return isTLS;
    }

    private boolean isChars(char c1, char c2, char c3, char c4) {
        return isAlphabetic(c1) && isAlphabetic(c2) && isAlphabetic(c3) && isAlphabetic(c4);
    }

    private boolean isABBA(char c1, char c2, char c3, char c4) {
        return c1 == c4 && c2 == c3 && c1 != c2;
    }
}
