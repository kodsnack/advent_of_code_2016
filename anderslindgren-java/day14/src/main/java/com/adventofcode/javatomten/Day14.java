package com.adventofcode.javatomten;

import java.io.IOException;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.*;
import java.util.stream.Collectors;


/**
 * Advent of Code 2016-12-14.
 */
public class Day14 {


    public static void main(String... args) throws IOException {
        Day14 day = new Day14();
        List<String> lines = day.parseArgs(args);
        day.parse(lines);
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


}
