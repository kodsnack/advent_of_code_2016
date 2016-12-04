package com.adventofcode.javatomten;

import java.io.IOException;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

/**
 * Advent of Code 2016-12-02.
 */
public class Day3 {

    private class Triangle {
        private final int sideA;
        private final int sideB;
        private final int sideC;

        Triangle(List<Integer> sides) {
            sideA = sides.get(0);
            sideB = sides.get(1);
            sideC = sides.get(2);
        }

        public boolean isValid() {
            return sideA + sideB > sideC;
        }

        public String toString() {
            return sideA + ", " + sideB + ", " + sideC + " : " + isValid();
        }
    }

    public static void main(String... args) throws IOException {
        Day3 day = new Day3();
        List<String> lines = day.parseArgs(args);
        day.parse(lines);
    }

    private List<String> parseArgs(String[] args) throws IOException {
        Path path = FileSystems.getDefault().getPath(args[0]);
        return Files.readAllLines(path);
    }

    private void parse(List<String> lines) {
        int valids = 0;
        for (String line : lines) {
            final String[] sides = line.trim().split(" +");
            final List<Integer> triSides = new ArrayList<>();
            for (final String side : sides) {
                final int s = Integer.parseInt(side);
                triSides.add(s);
            }
            Collections.sort(triSides);
            Triangle triangle = new Triangle(triSides);
            if (triangle.isValid()) {
                valids++;
            }
        }
        System.out.println(valids);
    }


}
