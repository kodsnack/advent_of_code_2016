package com.adventofcode.javatomten;

import java.io.IOException;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


/**
 * Advent of Code 2016-12-12.
 */
public class Day12 {

    private class Registry {
        private int value;

        Registry() {

        }

        int getValue() {
            return value;
        }

        void setValue(int value) {
            this.value = value;
        }

        void inc() {
            value++;
        }

        void dec() {
            value--;
        }
    }

    private interface Instruction {
        void apply(Map<String, Registry> registers);
    }

    private class Cpy implements Instruction {
        private final String regId;
        private final int value;
        private final String dest;

        Cpy(String regId, String dest) {
            this.regId = regId;
            this.value = 0;
            this.dest = dest;
        }

        Cpy(int value, String dest) {
            this.regId = null;
            this.value = value;
            this.dest = dest;
        }

        @Override
        public void apply(Map<String, Registry> registers) {
            int v;
            if (regId != null) {
                Registry r = registers.get(regId);
                v = r.getValue();
            } else {
                v = value;
            }
            registers.get(dest).setValue(v);
        }

        @Override
        public String toString() {
            String val;
            if (regId != null) {
                val = regId;
            }
            else {
                val = "" + value;
            }
            return "Cpy{" +
                    "from='" + val + '\'' +
                    ", dest='" + dest + '\'' +
                    '}';
        }
    }

    private class Inc implements Instruction {
        private final String regId;

        Inc(String registry) {
            this.regId = registry;
        }

        @Override
        public void apply(Map<String, Registry> registers) {
            registers.get(regId).inc();
        }

        @Override
        public String toString() {
            return "Inc{" +
                    "regId='" + regId + '\'' +
                    '}';
        }
    }

    private class Dec implements Instruction {
        private final String regId;

        Dec(String regId) {
            this.regId = regId;
        }

        @Override
        public void apply(Map<String, Registry> registers) {
            registers.get(regId).dec();
        }

        @Override
        public String toString() {
            return "Dec{" +
                    "regId='" + regId + '\'' +
                    '}';
        }
    }

    private class Jnz implements Instruction {
        private final String regId;
        private final int jump;
        private final int intVal;

        Jnz(String regId, int jump) {
            this.intVal = 0;
            this.regId = regId;
            this.jump = jump;
        }

        Jnz(int intVal, int jump) {
            this.intVal = intVal;
            this.regId = null;
            this.jump = jump;
        }

        @Override
        public void apply(Map<String, Registry> registers) {

        }

        @Override
        public String toString() {
            String val;
            if (regId != null) {
                val = regId;
            }
            else {
                val = "" + intVal;
            }
            return "Jnz{" +
                    "input='" + val + '\'' +
                    ", jump=" + jump +
                    '}';
        }
    }


    private Pattern cpyPattern = Pattern.compile("cpy ([0-9a-d]+) ([a-d])");
    private Pattern incPattern = Pattern.compile("inc ([a-d])");
    private Pattern decPattern = Pattern.compile("dec ([a-d])");
    private Pattern jnzPattern = Pattern.compile("jnz ([0-9a-d]) (-?[0-9]+)");

    private List<Instruction> instructions = new ArrayList<>();

    private Map<String, Registry> registers = new HashMap<>();

    private Day12() {
        registers.put("a", new Registry());
        registers.put("b", new Registry());
        registers.put("c", new Registry());
        registers.put("d", new Registry());
    }

    public static void main(String... args) throws IOException {
        Day12 day = new Day12();
        List<String> lines = day.parseArgs(args);
        day.parse(lines);
    }

    private List<String> parseArgs(String[] args) throws IOException {
        Path path = FileSystems.getDefault().getPath(args[0]);
        return Files.readAllLines(path);
    }


    private void parse(List<String> data) {
        data.forEach(this::parseLine);
        execute();
    }

    private void execute() {
        registers.entrySet()
                .forEach(es -> System.out.printf("%s: %d, ", es.getKey(), es.getValue().getValue()));
        System.out.println();
        for (int i = 0; i < instructions.size(); i++) {
            Instruction instr = instructions.get(i);

            System.out.printf("[%d] %s => ", i, instr.toString());
            if (instr instanceof Jnz) {
                final Jnz jnz = (Jnz) instr;
                int value;
                if (jnz.regId != null) {
                    final Registry registry = registers.get(jnz.regId);
                    value = registry.value;
                }
                else {
                    value = jnz.intVal;
                }
                if (value != 0) {
                    i += jnz.jump - 1;
                }
                else {
                    System.out.println("Ignore since value is 0");
                }
            }
            else {
                instr.apply(registers);
            }
            registers.entrySet()
                    .forEach(es -> System.out.printf("%s: %d, ", es.getKey(), es.getValue().getValue()));
            System.out.println();
        }
    }

    private void parseLine(String data) {
        Matcher cpyMatcher = cpyPattern.matcher(data);
        Matcher incMatcher = incPattern.matcher(data);
        Matcher decMatcher = decPattern.matcher(data);
        Matcher jnzMatcher = jnzPattern.matcher(data);
        if (cpyMatcher.find()) {
            final String value = cpyMatcher.group(1);
            final String dest = cpyMatcher.group(2);
            Cpy cpy;
            if (Character.isLetter(value.charAt(0))) {
                cpy = new Cpy(value, dest);
            }
            else {
                cpy = new Cpy(Integer.parseInt(value), dest);
            }
            instructions.add(cpy);
        } else if (incMatcher.find()) {
            final String reg = incMatcher.group(1);
            Inc inc = new Inc(reg);
            instructions.add(inc);
        } else if (decMatcher.find()) {
            final String reg = decMatcher.group(1);
            Dec dec = new Dec(reg);
            instructions.add(dec);
        } else if (jnzMatcher.find()) {
            final String regId = jnzMatcher.group(1);
            final int jump = Integer.parseInt(jnzMatcher.group(2));
            Jnz jnz;
            if (Character.isLetter(regId.charAt(0))) {
                jnz = new Jnz(regId, jump);
            }
            else {
                final int intVal = Integer.parseInt(regId);
                jnz = new Jnz(intVal, jump);
            }
            instructions.add(jnz);
        }

    }
}
