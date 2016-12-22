package com.adventofcode.javatomten;

import java.io.IOException;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;


/**
 * Advent of Code 2016-12-09.
 */
public class Day9_2 {

    public static void main(String... args) throws IOException {
        Day9_2 day = new Day9_2();
        List<String> lines = day.parseArgs(args);
        day.parse(lines);
    }

    private List<String> parseArgs(String[] args) throws IOException {
        Path path = FileSystems.getDefault().getPath(args[0]);
        return Files.readAllLines(path);
    }

    private void parse(List<String> data) {
        data.forEach((d) -> {long i = decompress(d); System.out.printf("%d", i);});
    }

    enum State {LENGTH, DUPLICATOR, TEXT, DUPLICATION}

    private long decompress(String data) {
        long result = 0;
        State state = State.TEXT;
        int length = 0;
        int duplicator = 0;
        StringBuilder sb = new StringBuilder();
        final char[] chars = data.toCharArray();
        for (char c : chars) {
            if (c == '(' && state == State.TEXT) {
                state = State.LENGTH;
                result += sb.length();
                sb = new StringBuilder();
                continue;
            }
            else if (c == 'x' && state == State.LENGTH) {
                state = State.DUPLICATOR;
                length = Integer.parseInt(sb.toString());
                sb = new StringBuilder();
                continue;
            }
            else if (c == ')' && state == State.DUPLICATOR) {
                state = State.DUPLICATION;
                duplicator = Integer.parseInt(sb.toString());
                sb = new StringBuilder();
                continue;
            }
            sb.append(c);
            if (sb.length() == length && state == State.DUPLICATION) {
                for (int x = 0; x < duplicator; x++) {
                    result += decompress(sb.toString());
                }
                sb = new StringBuilder();
                length = 0;
                duplicator = 0;
                state = State.TEXT;
            }
        }
        if (state == State.TEXT && sb.length() > 0) {
            result += sb.length();
        }
        return result;
    }

}
