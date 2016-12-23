package com.adventofcode.javatomten;

import java.io.IOException;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

/**
 * Advent of Code 2016-12-02.
 */
public class Day2 {


    private class Keypad {

        private int currentNumber = 5;

        public void go(char move) {
            switch (move) {
                case 'U':
                    if (currentNumber > 3) currentNumber -= 3;
                    break;
                case 'R':
                    if (currentNumber != 3 && currentNumber != 6 && currentNumber != 9) currentNumber++;
                    break;
                case 'D':
                    if (currentNumber < 7) currentNumber += 3;
                    break;
                case 'L':
                    if (currentNumber != 1 && currentNumber != 4 && currentNumber != 7) currentNumber--;
                    break;
            }
        }

        public int getCurrentNumber() {
            return currentNumber;
        }
    }

    public static void main(String... args) throws IOException {
        Day2 day = new Day2();
        List<String> lines = day.parseArgs(args);
        day.parse(lines);
    }

    private List<String> parseArgs(String[] args) throws IOException {
        Path path = FileSystems.getDefault().getPath(args[0]);
        return Files.readAllLines(path);
    }

    private void parse(List<String> lines) {
        Keypad keypad = new Keypad();
        for (String line : lines) {
            for (char move : line.toCharArray()) {
                keypad.go(move);
            }
            System.out.print(keypad.getCurrentNumber());
        }
        System.out.println();
    }


}
