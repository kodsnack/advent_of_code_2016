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
public class Day1_2 {

    private enum Heading {NORTH, EAST, SOUTH, WEST}

    private class Coordinate {
        final int x;
        final int y;

        Coordinate(int x, int y) {
            this.x = x;
            this.y = y;
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (o == null || getClass() != o.getClass()) return false;

            Coordinate that = (Coordinate) o;

            return x == that.x && y == that.y;

        }

        @Override
        public int hashCode() {
            int result = x;
            result = 31 * result + y;
            return result;
        }

        public String toString() {
            return "[" + x + "," + y + "]";
        }
    }

    private class State {
        List<Coordinate> breadcrumbs = new ArrayList<>();
        Coordinate lastLocation;
        Coordinate finalLocation;
        Heading heading;

        State() {
            heading = Heading.NORTH;
            lastLocation =  new Coordinate(0, 0);
            breadcrumbs.add(lastLocation);
        }

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

        private void goWest(int length) {
            heading = Heading.WEST;
            Coordinate coordinate = lastLocation;
            for (int i = lastLocation.x - 1; i >= lastLocation.x - length; i--) {
                coordinate = new Coordinate(i, lastLocation.y);
                System.out.println(coordinate);
                if (breadcrumbs.contains(coordinate)) {
                    finalLocation = coordinate;
                    break;
                }
                breadcrumbs.add(coordinate);
            }
            lastLocation = coordinate;
        }

        private void goEast(int length) {
            heading = Heading.EAST;
            Coordinate coordinate = lastLocation;
            for (int i = lastLocation.x + 1; i <= lastLocation.x + length; i++) {
                coordinate = new Coordinate(i, lastLocation.y);
                System.out.println(coordinate);
                if (breadcrumbs.contains(coordinate)) {
                    finalLocation = coordinate;
                    break;
                }
                breadcrumbs.add(coordinate);
            }
            lastLocation = coordinate;
        }

        private void goSouth(int length) {
            heading = Heading.SOUTH;
            Coordinate coordinate = lastLocation;
            for (int i = lastLocation.y - 1; i >= lastLocation.y - length; i--) {
                coordinate = new Coordinate(lastLocation.x, i);
                System.out.println(coordinate);
                if (breadcrumbs.contains(coordinate)) {
                    finalLocation = coordinate;
                    break;
                }
                breadcrumbs.add(coordinate);
            }
            lastLocation = coordinate;
        }

        private void goNorth(int length) {
            heading = Heading.NORTH;
            Coordinate coordinate = lastLocation;
            for (int i = lastLocation.y + 1; i <= lastLocation.y + length; i++) {
                coordinate = new Coordinate(lastLocation.x, i);
                System.out.println(coordinate);
                if (breadcrumbs.contains(coordinate)) {
                    finalLocation = coordinate;
                    break;
                }
                breadcrumbs.add(coordinate);
            }
            lastLocation = coordinate;
        }

        boolean isFinalLocationReached() {
            return finalLocation != null;
        }

        int getDistance() {
            return Math.abs(finalLocation.x) + Math.abs(finalLocation.y);
        }
    }

    public static void main(String... args) throws IOException {
        Day1_2 day = new Day1_2();
        List<String> directions = day.parseArgs(args);
        int distance = day.parse(directions);
        System.out.println(distance);
    }

    private int parse(List<String> directions) {
        State state = new State();
        for (String direction : directions) {
            System.out.println(direction + ": ");
            char turn = direction.charAt(0);
            int length = Integer.parseInt(direction.substring(1));
            if (turn == 'L') {
                state.turnLeft(length);
            }
            if (turn == 'R') {
                state.turnRight(length);
            }
            if (state.isFinalLocationReached()) {
                return state.getDistance();
            }
        }
        return -1;
    }

    public Day1_2() {

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


}
