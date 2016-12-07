package com.adventofcode.javatomten;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Function;

import static java.util.stream.Collectors.counting;
import static java.util.stream.Collectors.groupingBy;
import static java.util.stream.Collectors.joining;

/**
 * Advent of Code 2016-12-06.
 */
public class Day6 {

    public static void main(String... args) throws IOException, NoSuchAlgorithmException {
        Day6 day = new Day6();
        List<String> lines = day.parseArgs(args);
        day.parse(lines);
    }

    private List<String> parseArgs(String[] args) throws IOException {
        Path path = FileSystems.getDefault().getPath(args[0]);
        return Files.readAllLines(path);
    }


    private void parse(List<String> lines) throws NoSuchAlgorithmException, UnsupportedEncodingException {

        List<Map<Character, Long>> dist = new ArrayList<>();
        for (int i = 0; i < lines.get(0).length(); i++) {
            dist.add(new HashMap<>());
        }
        for (String s : lines) {
            final char[] chars = s.toCharArray();
            for (int i = 0; i < chars.length; i++) {
                char c = chars[i];
                Map<Character, Long> m = dist.get(i);
                if (m.containsKey(c)) {
                    Long l = m.get(c) + 1;
                    m.put(c, l);
                } else {
                    m.put(c, 1L);
                }
            }
        }

        dist.forEach(m ->
                        m.entrySet().stream()
                                .sorted((e1, e2) -> e2.getValue().compareTo(e1.getValue()))
                                .limit(1)
                                .map(e -> e.getKey().toString())
                                .forEach(System.out::print)
        );

    }
}
