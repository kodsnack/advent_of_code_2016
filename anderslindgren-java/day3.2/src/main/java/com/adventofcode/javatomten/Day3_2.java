package com.adventofcode.javatomten;

import java.io.IOException;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Advent of Code 2016-12-03.
 */
public class Day3_2 {

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
        Day3_2 day = new Day3_2();
        List<String> lines = day.parseArgs(args);
        day.parse(lines);
    }

    private List<String> parseArgs(String[] args) throws IOException {
        Path path = FileSystems.getDefault().getPath(args[0]);
        return Files.readAllLines(path);
    }

    private void parse(List<String> lines) {
        int valids = 0;
        for (int i = 0; i < lines.size(); i+=3) {
            final List<Integer> triSides1 = new ArrayList<>();
            final List<Integer> triSides2 = new ArrayList<>();
            final List<Integer> triSides3 = new ArrayList<>();

            final String[] sides1 = lines.get(i).trim().split(" +");
            final String[] sides2 = lines.get(i+1).trim().split(" +");
            final String[] sides3 = lines.get(i+2).trim().split(" +");

            triSides1.add(Integer.parseInt(sides1[0]));
            triSides1.add(Integer.parseInt(sides2[0]));
            triSides1.add(Integer.parseInt(sides3[0]));

            triSides2.add(Integer.parseInt(sides1[1]));
            triSides2.add(Integer.parseInt(sides2[1]));
            triSides2.add(Integer.parseInt(sides3[1]));

            triSides3.add(Integer.parseInt(sides1[2]));
            triSides3.add(Integer.parseInt(sides2[2]));
            triSides3.add(Integer.parseInt(sides3[2]));

            Collections.sort(triSides1);
            Collections.sort(triSides2);
            Collections.sort(triSides3);

            Triangle triangle1 = new Triangle(triSides1);
            Triangle triangle2 = new Triangle(triSides2);
            Triangle triangle3 = new Triangle(triSides3);

            if (triangle1.isValid()) valids++;
            if (triangle2.isValid()) valids++;
            if (triangle3.isValid()) valids++;
        }
        System.out.println(valids);
    }


}
