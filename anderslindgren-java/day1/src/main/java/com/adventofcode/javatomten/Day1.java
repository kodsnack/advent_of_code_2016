package com.adventofcode.javatomten;

import java.io.BufferedReader;
import java.io.IOException;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * Advent of Code 2016-12-01.
 */
public class Day1 {

    private enum Heading {NORTH, EAST, SOUTH, WEST}

    private class State {
        int northSouth;
        int eastWest;
        Heading heading = Heading.NORTH;

        void turnLeft(int length) {
            switch (heading) {
                case NORTH:
                    goWest(length);
                    break;
                case EAST:
                    goNorth(length);
                    break;
                case SOUTH:
                    goEast(length);
                    break;
                case WEST:
                    goSouth(length);
                    break;
            }
        }

        void turnRight(int length) {
            switch (heading) {
                case NORTH:
                    goEast(length);
                    break;
                case EAST:
                    goSouth(length);
                    break;
                case SOUTH:
                    goWest(length);
                    break;
                case WEST:
                    goNorth(length);
                    break;
            }
        }

        private void goSouth(int length) {
            heading = Heading.SOUTH;
            northSouth -= length;
        }

        private void goEast(int length) {
            heading = Heading.EAST;
            eastWest += length;
        }

        private void goNorth(int length) {
            heading = Heading.NORTH;
            northSouth += length;
        }

        private void goWest(int length) {
            heading = Heading.WEST;
            eastWest -= length;
        }

        int getDistance() {
            return Math.abs(northSouth) + Math.abs(eastWest);
        }
    }

    public static void main(String... args) throws IOException {
        Day1 day = new Day1();
        List<String> directions = day.parseArgs(args);
        int distance = day.parse(directions);
        System.out.println(distance);
    }

    private List<String> parseArgs(String[] args) throws IOException {
        List<String> result = new ArrayList<>();
        Path path = FileSystems.getDefault().getPath(args[0]);
        BufferedReader reader = Files.newBufferedReader(path);
        String line = reader.readLine();
        String[] split = line.split(", ");
        result.addAll(Arrays.asList(split));

        return result;
    }

    private int parse(List<String> directions) {
        State state = new State();
        for (String direction : directions) {
            //System.out.print(direction + ": ");
            char turn = direction.charAt(0);
            int length = Integer.parseInt(direction.substring(1));
            if (turn == 'L') {
                state.turnLeft(length);
            }
            if (turn == 'R') {
                state.turnRight(length);
            }
        }
        return state.getDistance();
    }


}
