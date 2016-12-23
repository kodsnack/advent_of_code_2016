package com.adventofcode.javatomten;

import java.io.IOException;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import static java.lang.Character.isAlphabetic;
import static java.util.Arrays.asList;

/**
 * Advent of Code 2016-12-07.
 */
public class Day7_2 {

    public static void main(String... args) throws IOException {
        Day7_2 day = new Day7_2();
        List<String> lines = day.parseArgs(args);
        day.parse(lines);
    }

    private List<String> parseArgs(String[] args) throws IOException {
        Path path = FileSystems.getDefault().getPath(args[0]);
        return Files.readAllLines(path);
    }


    private void parse(List<String> lines) {
        int tlsable = 0;
        for (final String line : lines) {
            if (checkTLS(line)) {
                tlsable++;
            }
        }
        System.out.println(tlsable);
    }

    private boolean checkTLS(String line) {
        List<char[]> abas = new ArrayList<>();
        List<char[]> babs = new ArrayList<>();
        final char[] c = line.toCharArray();
        boolean isSSL = false;
        boolean inHypernet = false;
        for (int i = 0; i < c.length - 2; i++) {
            if (c[i] == '[') {
                inHypernet = true;
            } else if (c[i] == ']') {
                inHypernet = false;
            }
            if (isChars(c[i], c[i + 1], c[i + 2])
                    && isABAorBAB(c[i], c[i + 1], c[i + 2])) {
                if (!inHypernet) {
                    abas.add(new char[] {c[i], c[i + 1]});
                } else {
                    babs.add(new char[] {c[i], c[i + 1]});
                }
            }
        }
        if (checkABAvsBAB(abas, babs)) {
            isSSL = true;
            //System.out.println(line + " = " + isSSL);
        }
        return isSSL;
    }

    private boolean checkABAvsBAB(List<char[]> abas, List<char[]> babs) {
        if (abas.size() > 0 && babs.size() > 0) {
            for (char[] ab : abas) {
                for (char[] ba: babs) {
                    if (ab[0] == ba[1] && ab[1] == ba[0]) {
                        //System.out.println("" + ab[0] + ab[1] + ab[0] + " && " + ba[0] + ba[1] + ba[0]);
                        return true;
                    }
                }
            }
        }
        else {
            //System.out.println(abas.size() + " && " + babs.size());
        }
        return false;
    }

    private boolean isChars(char c1, char c2, char c3) {
        return isAlphabetic(c1) && isAlphabetic(c2) && isAlphabetic(c3);
    }

    private boolean isABAorBAB(char c1, char c2, char c3) {
        return (c1 == c3) && (c1 != c2);
    }
}
