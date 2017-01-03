package com.adventofcode.javatomten;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.IntStream;


/**
 * Advent of Code 2016-12-15.
 */
public class Day15_2 {

    private Pattern p = Pattern.compile("Disc #(?<id>\\d+) has (?<positions>\\d+) positions; at time=0, " +
            "it is at position (?<initial>\\d+).");
    private List<Disc> discs = new ArrayList<>();

    private class Disc {
        private final int id;
        private final int positions;
        private int current;

        public Disc(int id, int positions, int initial) {
            this.id = id;
            this.positions = positions;
            this.current = initial;
        }

        void advanceTime() {
            current++;
            if (current >= positions) {
                current = 0;
            }
        }

        boolean getAlignment() {
            return current % positions == (positions - (id % positions));
        }

        @Override
        public String toString() {
            final StringBuilder s = new StringBuilder();
            IntStream.range(0, positions).forEachOrdered(i -> {
                if (i == current) {
                    s.append("|   ");
                } else {
                    s.append("|<=>");
                }
            });
            s.append("|");
            return "#" + id + "  " + s;
        }
    }


    public static void main(String... args) throws IOException, NoSuchAlgorithmException {
        Day15_2 day = new Day15_2();
        List<String> lines = day.parseArgs(args);
        day.parse(lines);
    }


    private List<String> parseArgs(String[] args) throws IOException {
        Path path = FileSystems.getDefault().getPath(args[0]);
        return Files.readAllLines(path);
    }

    private void parse(List<String> data) throws UnsupportedEncodingException, NoSuchAlgorithmException {
        data.forEach(this::parseLine);
        solve();
    }

    /**
     * Parse lines like this:
     * <pre>
     * Disc #1 has 5 positions; at time=0, it is at position 4.
     * </pre>
     *
     * @param line The line to parse
     */
    private void parseLine(String line) {
        final Matcher matcher = p.matcher(line);
        if (matcher.matches()) {
            final int id = Integer.parseInt(matcher.group("id"));
            final int positions = Integer.parseInt(matcher.group("positions"));
            final int initial = Integer.parseInt(matcher.group("initial"));
            Disc d = new Disc(id, positions, initial);
            discs.add(d);
        }

    }


    private void solve() throws NoSuchAlgorithmException, UnsupportedEncodingException {
        for (int i = 0; i < 10000000; i++) {
            if (discs.parallelStream().allMatch(Disc::getAlignment)) {
                System.out.println("=== " + i + " ===");
                discs.forEach(System.out::println);
                break;
            }
            discs.forEach(Disc::advanceTime);
        }

    }
}
