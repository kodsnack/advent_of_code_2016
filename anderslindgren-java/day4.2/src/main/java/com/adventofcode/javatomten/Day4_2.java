package com.adventofcode.javatomten;

import java.io.IOException;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.function.Function;

import static java.util.stream.Collectors.*;

/**
 * Advent of Code 2016-12-04.
 */
public class Day4_2 {

    private class EntryCompare implements Comparator<Map.Entry<Character, Long>> {

        @Override
        public int compare(Map.Entry<Character, Long> o1, Map.Entry<Character, Long> o2) {
            final int valueComp = o2.getValue().compareTo(o1.getValue());
            if (valueComp == 0) {
                return o1.getKey().compareTo(o2.getKey());
            }
            return valueComp;
        }
    }

    private class Room {

        private final static int l = (int) 'z' - (int) 'a' + 1;
        private final String checksum;
        private final int sector;
        private final String truth;
        private final String encrypted;

        public Room(String s) {
            int i = s.indexOf('[');
            checksum = s.substring(i + 1, s.length() - 1);
            //System.out.println(checksum);
            s = s.substring(0, i);
            //System.out.println(s);
            i = s.lastIndexOf('-');
            sector = Integer.parseInt(s.substring(i + 1));
            //System.out.println(sector);
            s = s.substring(0, i);
            //System.out.println(s);
            encrypted = s;

            Map<Character, Long> m = s.chars()
                    .mapToObj(c -> (char) c)
                    .filter(Character::isAlphabetic)
                    .collect(groupingBy(Function.identity(), counting()));
            //System.out.println(m);
            truth = m.entrySet().stream()
                    .sorted(new EntryCompare())
                    .limit(5)
                    .map(e -> e.getKey().toString())
                    .collect(joining());
            //System.out.println(checksum + "=" + truth + ": " + checksum.equals(truth));
        }

        public String decrypt() {
            String result = "";
            String[] strs = encrypted.split("-");
            for (String s : strs) {
                String decrypted = s.chars()
                        .map(c -> (((c - 'a') + sector) % l) + 'a')
                        .mapToObj(i -> "" + (char) i)
                        .collect(joining());
                result += decrypted + " ";
            }

            return result;
        }

        public boolean isValidRoom() {
            return checksum.equals(truth);
        }

        public int getSector() {
            return sector;
        }
    }

    public static void main(String... args) throws IOException {
        Day4_2 day = new Day4_2();
        List<String> lines = day.parseArgs(args);
        day.parse(lines);
    }

    private List<String> parseArgs(String[] args) throws IOException {
        Path path = FileSystems.getDefault().getPath(args[0]);
        return Files.readAllLines(path);
    }


    private void parse(List<String> lines) {
        int sectorSum = 0;
        for (String line : lines) {
            Room room = new Room(line);
            if (room.isValidRoom()) {
                sectorSum += room.getSector();
                System.out.println(room.getSector() + ": " + room.decrypt());
            }
        }
        System.out.println(sectorSum);
    }
}
