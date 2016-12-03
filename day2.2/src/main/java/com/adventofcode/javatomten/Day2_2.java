package com.adventofcode.javatomten;

import java.io.IOException;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

/**
 * Advent of Code 2016-12-02.
 */
public class Day2_2 {

    private class Key {
        private final char value;
        private Key up;
        private Key right;
        private Key down;
        private Key left;

        Key(char value) {
            this.value = value;
        }

        public Key above(Key key) {
            up = key;
            return this;
        }
        public Key rightOf(Key key) {
            right = key;
            return this;
        }
        public Key below(Key key) {
            down = key;
            return this;
        }
        public Key leftOf(Key key) {
            left = key;
            return this;
        }

        public char getValue() {
            return value;
        }

        public String toString() {
            return "" + value;
        }
    }

    private class Keypad {

        private final Key k1;
        private final Key k2;
        private final Key k3;
        private final Key k4;
        private final Key k5;
        private final Key k6;
        private final Key k7;
        private final Key k8;
        private final Key k9;
        private final Key kA;
        private final Key kB;
        private final Key kC;
        private final Key kD;

        private Key currentKey;

        Keypad() {
            k1 = new Key('1');
            k2 = new Key('2');
            k3 = new Key('3');
            k4 = new Key('4');
            k5 = new Key('5');
            k6 = new Key('6');
            k7 = new Key('7');
            k8 = new Key('8');
            k9 = new Key('9');
            kA = new Key('A');
            kB = new Key('B');
            kC = new Key('C');
            kD = new Key('D');

            k1.above(k1).rightOf(k1).below(k3).leftOf(k1);
            k2.above(k2).rightOf(k3).below(k6).leftOf(k2);
            k3.above(k1).rightOf(k4).below(k7).leftOf(k2);
            k4.above(k4).rightOf(k4).below(k8).leftOf(k3);
            k5.above(k5).rightOf(k6).below(k5).leftOf(k5);
            k6.above(k2).rightOf(k7).below(kA).leftOf(k5);
            k7.above(k3).rightOf(k8).below(kB).leftOf(k6);
            k8.above(k4).rightOf(k9).below(kC).leftOf(k7);
            k9.above(k9).rightOf(k9).below(k9).leftOf(k8);
            kA.above(k6).rightOf(kB).below(kA).leftOf(kA);
            kB.above(k7).rightOf(kC).below(kD).leftOf(kA);
            kC.above(k8).rightOf(kC).below(kC).leftOf(kB);
            kD.above(kB).rightOf(kD).below(kD).leftOf(kD);

            currentKey = k5;
        }

        public void go(char move) {
            //System.out.print(currentKey + ": " + move);
            switch (move) {
                case 'U': currentKey = currentKey.up; break;
                case 'R': currentKey = currentKey.right; break;
                case 'D': currentKey = currentKey.down; break;
                case 'L': currentKey = currentKey.left; break;
            }
            //System.out.println(" = " + currentKey);
        }

        public char getCurrentNumber() {
            return currentKey.getValue();
        }
    }

    public static void main(String... args) throws IOException {
        Day2_2 day = new Day2_2();
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
