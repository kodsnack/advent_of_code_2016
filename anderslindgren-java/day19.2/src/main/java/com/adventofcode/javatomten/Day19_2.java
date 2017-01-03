package com.adventofcode.javatomten;

import java.io.IOException;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayDeque;
import java.util.Deque;
import java.util.List;


/**
 * Advent of Code 2016-12-19.
 */
public class Day19_2 {

    public static void main(String... args) throws IOException, NoSuchAlgorithmException {
        Day19_2 day = new Day19_2();
        List<String> lines = day.parseArgs(args);
        day.parse(lines);
    }

    private List<String> parseArgs(String[] args) throws IOException {
        Path path = FileSystems.getDefault().getPath(args[0]);
        return Files.readAllLines(path);
    }

    private void parse(List<String> lines) {
        lines.forEach(this::parse);
    }

    private void parse(String line) {
        final int input = Integer.parseInt(line);

        Deque<Integer> leftQueue = new ArrayDeque<>();
        Deque<Integer> rightQueue = new ArrayDeque<>();

        for (int i = 1; i <= (input / 2); i++) {
            leftQueue.add(i);
        }

        for (int i = input; i > (input / 2); i--) {
            rightQueue.add(i);
        }
        while (leftQueue.size() > 0 && rightQueue.size() > 0) {
            if (leftQueue.size() > rightQueue.size()) {
                leftQueue.removeLast();
            } else {
                rightQueue.removeLast();
            }
            rightQueue.addFirst(leftQueue.removeFirst());
            leftQueue.addLast(rightQueue.removeLast());
        }
        if (leftQueue.size() > 0)
            System.out.printf("%2d: %2d\n", input, leftQueue.getFirst());
        else
            System.out.printf("%2d: %2d\n", input, rightQueue.getFirst());
    }

}
