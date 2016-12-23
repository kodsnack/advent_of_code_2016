package com.adventofcode.javatomten;

import java.io.IOException;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.*;
import java.util.stream.Collectors;


/**
 * Advent of Code 2016-12-13.
 */
public class Day13 {

    private static final int MAX_X = 50;
    private static final int MAX_Y = 50;
    private static final int MAX_TRIES =10000;
    private final char[][] maze = new char[MAX_X][MAX_Y];

    private Pair goal = new Pair(31, 39);
    //private Pair goal = new Pair(3, 2);
    private final List<Pair> connected = new ArrayList<>();
    private int paths;
    private List<Pair> shortest;

    private class Pair {

        private final int x;
        private final int y;

        Pair(int x, int y) {
            this.x = x;
            this.y = y;
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (o == null || getClass() != o.getClass()) return false;
            Pair other = (Pair) o;
            return x == other.x && y == other.y;
        }

        @Override
        public int hashCode() {
            int result = x;
            result = 31 * result + y;
            return result;
        }

        @Override
        public String toString() {
            return "[" + x + "," + y + ']';
        }
    }


    public static void main(String... args) throws IOException {
        Day13 day = new Day13();
        List<String> lines = day.parseArgs(args);
        day.parse(lines);
        day.solve();
    }

    private void solve() {
        System.out.println(goal + " is " + (connected.contains(goal) ? "" : "not ") + "a path");
        final ArrayList<Pair> oldPath = new ArrayList<>();
        oldPath.add(new Pair(1, 1));
        next(oldPath);

        System.out.println("Got in total " + paths);
        printMaze(shortest);
        // The number of steps doesn't include the initial location, hence "-1"
        System.out.println("Shortest path is: " + (shortest.size() - 1));
    }

    private void next(List<Pair> oldPath) {
        final List<Pair> next = extendPath(oldPath);

        for (final Pair pair : next) {
            final List<Pair> newPath = new ArrayList<>(oldPath);
            newPath.add(pair);

            if (pair.equals(goal)) {
                paths++;
                if (shortest == null || newPath.size() < shortest.size()) {
                    shortest = newPath;
                }
                return;
            }
            if (paths >= MAX_TRIES) {
                System.out.println("Stopping at " + MAX_TRIES + " possible paths");
                return;
            }
            next(newPath);
        }
    }

    /**
     * Take a list of Pairs and return a list of possible next Pairs.
     *
     * @param path previous pairs in the path.
     * @return list of possible next steps.
     */
    private List<Pair> extendPath(List<Pair> path) {
        final Pair pair = path.get(path.size() - 1);
        if (pair.equals(goal)) {
            return path;
        }
        final List<Pair> candidates = new ArrayList<>();
        candidates.add(new Pair(pair.x + 1, pair.y));
        candidates.add(new Pair(pair.x - 1, pair.y));
        candidates.add(new Pair(pair.x, pair.y + 1));
        candidates.add(new Pair(pair.x, pair.y - 1));

        return candidates.stream()
                .filter(p -> connected.contains(p) && !path.contains(p))
                .collect(Collectors.toList());

    }

    private List<String> parseArgs(String[] args) throws IOException {
        Path path = FileSystems.getDefault().getPath(args[0]);
        return Files.readAllLines(path);
    }


    private void parse(List<String> data) {
        data.stream()
                .map(Integer::parseInt)
                .forEach(this::generateMaze);
    }


    private void generateMaze(int input) {
        for (int y = 0; y < MAX_Y; y++) {
            for (int x = 0; x < MAX_X; x++) {
                long t = (x * x) + (3 * x) + (2 * x * y) + y + (y * y);
                t += input;
                boolean isOpenSpace = Long.toBinaryString(t).chars()
                        .mapToObj(i -> (char) i)
                        .filter(c -> c == '1')
                        .count() % 2 == 0;
                if (isOpenSpace) {
                    maze[x][y] = '.';
                    connected.add(new Pair(x, y));
                } else {
                    maze[x][y] = '\u2588';
                }
            }
        }
    }

    private void printMaze(List<Pair> path) {
        System.out.print("   ");

        for (int i = 0; i < MAX_X; i++) {
            if (i > 0 && i % 10 == 0) {
                System.out.print(i / 10);
            } else {
                System.out.print(' ');
            }
        }
        System.out.println();
        System.out.print("   ");
        for (int x = 0; x <= MAX_X / 10; x++) {
            for (int i = 0; i < 10; i++) {
                System.out.print(i);
            }
        }
        System.out.println();

        for (int y = 0; y < MAX_Y; y++) {
            System.out.printf("%2d ", y);
            for (int x = 0; x < MAX_X; x++) {
                if (path.contains(new Pair(x, y))) {
                    System.out.print('o');
                } else {
                    System.out.print(maze[x][y]);
                }
            }
            System.out.println();
        }

    }
}
