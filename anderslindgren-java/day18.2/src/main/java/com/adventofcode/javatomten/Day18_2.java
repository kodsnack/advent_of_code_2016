package com.adventofcode.javatomten;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.security.NoSuchAlgorithmException;
import java.util.List;


/**
 * Advent of Code 2016-12-18.
 */
public class Day18_2 {

    private static final int MAX_ROWS = 400000;
    private static final char TRAP = '^';
    private static final char SAFE = '.';


    public static void main(String... args) throws IOException, NoSuchAlgorithmException {
        Day18_2 day = new Day18_2();
        List<String> lines = day.parseArgs(args);
        day.parse(lines.get(0));
    }


    private List<String> parseArgs(String[] args) throws IOException {
        Path path = FileSystems.getDefault().getPath(args[0]);
        return Files.readAllLines(path);
    }


    private void parse(String line) throws UnsupportedEncodingException, NoSuchAlgorithmException {
        final StringBuilder floor = new StringBuilder();

        floor.append(line);

        int rows = 1;
        while (rows < MAX_ROWS) {
            line = solve(line);
            floor.append(line);
            rows++;
        }

        final long count = floor.chars()
                .mapToObj(i -> (char) i)
                .filter(c -> c == SAFE)
                .count();

        System.out.println(count);
    }

    private String solve(String line) throws NoSuchAlgorithmException, UnsupportedEncodingException {
        char[] tiles = line.toCharArray();
        char[] newTiles = new char[tiles.length];
        for (int i = 0; i < tiles.length; i++) {
            char left, right;
            if (i == 0) {
                left = '.';
            }
            else {
                left = tiles[i - 1];
            }
            if (i == tiles.length - 1) {
                right = SAFE;
            }
            else {
                right = tiles[i + 1];
            }
            if ((isTrap(left) && isSafe(right)) || (isSafe(left) && isTrap(right))) {
                newTiles[i] = TRAP;
            }
            else {
                newTiles[i] = SAFE;
            }
        }
        return new String(newTiles);
    }

    private boolean isSafe(char tile) {
        return tile == SAFE;
    }

    private boolean isTrap(char tile) {
        return tile == TRAP;
    }


}
